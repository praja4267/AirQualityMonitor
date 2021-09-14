//
//  ViewController.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var aqiTableView: UITableView!
    var webSocketConnection: WebSocketConnection!
    var totalEntries = [String: AQIModel]()
    var titles = [String]()
    var dataEntries: [AQIModel] = [] {
        didSet {
            updateTotalEntries(with: dataEntries)
        }
    }
    var detailViewController: DetailViewController?
    var refreshButton : UIBarButtonItem!
    struct Constants {
        static let websocketURL = "ws://city-ws.herokuapp.com/"
        static let pageTitle = "Air Quality Index"
        static let refresh = "Refresh"
        static let noInternetTitle = "No Internet Conection"
        static let noInternetMessage = "Please check your internet coneection and try again"
        static let tableViewCellIdentifier = "AQITableViewCell"
        static let detailVC = "DetailViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.pageTitle
        refreshButton = UIBarButtonItem(title:Constants.refresh , style: .done, target: self, action: #selector(refresh))
        checkNetworkStatusAndEstablishWSConnection()
        setUpTableView()
    }
    
    func updateList(list: [AQIModel]) {
        dataEntries = list
        aqiTableView.reloadData()
        updateModelOfDetailPage(list: list)
    }
    
    func updateTotalEntries(with dataEntries: [AQIModel]) {
        for model in dataEntries {
            totalEntries[model.city] = model
        }
        titles = totalEntries.keys.sorted()
    }
    
    func checkNetworkStatusAndEstablishWSConnection() {
            self.appDelegate.reachability.whenReachable = { [self] reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                appDelegate.isReachable = true
                setupWebsocket()
                self.navigationController?.navigationBar.barTintColor = UIColor.white
                self.navigationItem.rightBarButtonItem  = nil
            }
            self.appDelegate.reachability.whenUnreachable = { _ in
                self.appDelegate.isReachable = false
                print("Not reachable")
                self.showNoInternetUI()
            }
    }
    
    func showNoInternetUI() {
        self.showAlert(title:Constants.noInternetTitle , message: Constants.noInternetMessage)
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationItem.rightBarButtonItem  = refreshButton
    }
    
    @objc func refresh() {
        if appDelegate.isReachable {
            checkNetworkStatusAndEstablishWSConnection()
        } else {
            showNoInternetUI()
        }
    }
    // MARK: Update detail page model
    func updateModelOfDetailPage(list: [AQIModel]) {
        if detailViewController != nil && self.navigationController?.viewControllers.count ?? 1 > 1 {
            let filteredList = list.filter{$0.city == detailViewController?.model?.city}
            if let model =  filteredList.first{
                detailViewController?.model = model
            }
        }
    }
}

// MARK: Websocket connection related code
extension ViewController:  WebSocketConnectionDelegate {
    func setupWebsocket() {
        webSocketConnection = WebSocketTaskConnection(url: URL(string: Constants.websocketURL)!)
        webSocketConnection.delegate = self
        webSocketConnection.connect()
        webSocketConnection.send(text: "ping")
    }
    
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected with error:\(error)")
        } else {
            print("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        guard let data =  text.data(using: .utf8) else { return }
        do {
            let info = try JSONDecoder().decode([AQIModel].self, from: data)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateList(list: info)
            }
        }catch _ { }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
//        print("Data message: \(data)")
    }
    
}

// MARK: TableView realted code
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setUpTableView() {
        //
        aqiTableView.dataSource = self
        aqiTableView.delegate = self
        aqiTableView.separatorStyle = .none
        aqiTableView.register(UINib(nibName:Constants.tableViewCellIdentifier , bundle: nil), forCellReuseIdentifier: Constants.tableViewCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath) as? AQITableViewCell else { return UITableViewCell() }
        cell.updateUI(with: totalEntries[titles[indexPath.row]])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constants.detailVC) as? DetailViewController else {
            return
        }
        detailViewController = controller
        let model = totalEntries[titles[indexPath.row]]
        detailViewController!.model = model
        self.navigationController?.pushViewController(detailViewController!, animated: true)
    }
}
