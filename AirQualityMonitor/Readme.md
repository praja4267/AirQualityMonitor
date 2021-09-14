
# Air Quality Index Monitor
 ### Overview
This application has 2 Pages
- List of Air Quality indices of different cities
- Details of Air Quality Index of selected city

### Features
##### _First Screen_

 - The first screen shows the actual Air Quality Index of each city in Alphabetical order .
 - The colors of the progress bar indicates the severity of the AQI. 
 - The List of cities is shown in a dynamically increasing scroll view so that if we get info of more number of cities form server it will be added to the list and can be seen by scrollin up/down based on the name of the city. 
 - Below the name of city the last updated time is shown like few seconds , hours, days ago to indicate whether the data shown is latest or not.
##### _Second Screen_
- The second screen has a circular progress view whose parts are filled with different colors based on the severity. 
- Based on the different colors we can compare the severity of AQI. 
- It also displays the actual AQI of selected city and the description of the AQI based on the AQI guide lines given by Central Pollution Control Board.
- AQI reference guide given by Central pollution control board is added at the bottom of the page for reference.

### Open source code usage info
- used ReachabilitySwift to know the network status of the device
- Used MKMagneticProgress view to show the circular progress based on the AQI

### Time taken to complete the task
-  around 10 hours
