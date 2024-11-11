# STAT451-final-project

Group Members: Simon Xiong, Gefei Shen, Xuhao Wang, Tao Zhang

Summary:
With smartphones being one of the most important carry-alls in modern times (especially for young people), we wanted to find out if different types, number of apps installed, and other variations would have an impact on our usage habits.


## Data Source

[Mobile Device Usage and User Behavior Dataset](https://www.kaggle.com/datasets/valakhorasani/mobile-device-usage-and-user-behavior-dataset?resource=download)


| **Field**                   | **Description**                                                              |
|-----------------------------|------------------------------------------------------------------------------|
| `userID`                    | Unique identifier assigned to each user.                                     |
| `Device Model`              | Model name of the device (e.g., iPhone).                                     |
| `Operating System`          | Operating system running on the device (e.g., iOS, Android).                 |
| `App Usage Time`            | Total daily time spent using mobile applications, measured in minutes.       |
| `Screen On Time`            | Average hours per day the screen is active.                                  |
| `Battery Drain`             | Daily battery consumption in mAh.                                            |
| `Number of Apps Installed`  | Total number of apps installed on the device.                                |
| `Data Usage`                | Daily mobile data consumption, measured in megabytes.                        |
| `Age`                       | Age of the user.                                                             |
| `Gender`                    | Gender of the user (Male or Female).                                         |
| `User Behavior Class`       | Classification of user behavior based on usage patterns (scale of 1 to 5).   |


Some data exploration: in this data set, device model, operating system, age, gender and user behavior class are the categorical variables. userID, App Usage time, Screen on Time, Battery Drain, Number of Apps Installed, Data Usage are the numerical variables.  

## Analysis Questions
1. **What are the number of device models across different age groups?**  
   - **Potential Visualization:** Use a pie chart with different sections representing various age groups to show the distribution of device models among different age ranges.

2. **How does screen time vary by different age groups?**  
   - **Potential Visualization:** Use a line chart with different colors to represent each gender, illustrating the variation in screen time across age groups.

3. **Does the amount of time spent on the phone daily correlate with the number of apps on that person's phone?**  
   - **Potential Visualization:** Use a Correlation Matrix Plot to examine the relationship between daily phone usage time and the number of installed apps.

4. **What is the distribution of app usage time across different age groups?**  
   - **Potential Visualization:** Use a Box Plot to display the distribution of app usage time among various age groups, allowing for easy comparison of usage patterns.

5. **Is the use of different device models or operating systems correlated with the length of screen usage or the number of apps installed?**  
   - **Potential Visualization:** Use a Correlation Matrix Plot to analyze the relationship between device model/OS type and screen usage or app count. 


