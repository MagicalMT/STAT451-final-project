# STAT451-final-project

## Group Members

| Name         | GitHub Username |
|--------------|------------------|
| Simon Xiong  | MagicalMT        |
| Gefei Shen   | iefegensh        |
| Xuhao Wang   | Xuhaow2          |
| Tao Zhang    | TaoZhang111      |

## Summary:
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
1. **What is the preferred operating system for each age group?**  
   - **Potential Visualization:** Use a pie chart with different sections representing various age groups to show the distribution of device models among different age ranges.

2. **How does screen time vary by different age groups?**  
   - **Potential Visualization:** Use a line chart with different colors to represent each gender, illustrating the variation in screen time across age groups.

3. **Does the amount of time spent on the phone daily correlate with the number of apps on that person's phone?**  
   - **Potential Visualization:** Use a Correlation Matrix Plot to examine the relationship between daily phone usage time and the number of installed apps.

4. **What is the distribution of app usage time across different age groups?**  
   - **Potential Visualization:** Use a Box Plot to display the distribution of app usage time among various age groups, allowing for easy comparison of usage patterns.

5. **Is the use of different device models or operating systems correlated with the length of screen usage or the number of apps installed?**  
   - **Potential Visualization:** Use a Correlation Matrix Plot to analyze the relationship between device model/OS type and screen usage or app count. 

## Question 1: What is the preferred operating system for each age group?
![Operating System Preference by Age Group](https://github.com/MagicalMT/STAT451-final-project/blob/main/p1.png)
This chart shows the preference for operating systems (Android and iOS) by age group, revealing the proportion of users in each age group who use the different systems. As can be seen from the chart, Android dominates across all age groups, with the percentage of users ranging between 78% and 80%, demonstrating dominance. In contrast, iOS has a lower percentage of users, holding steady at around 20 per cent.In terms of age groups, although iOS has seen a small rise in the older 49-60 age group (to 22 per cent), overall this change has not altered the dominance of Android across all age groups. There is a general preference for Android across all age groups, with Android particularly favoured in the younger to middle age group (18-48).The pie chart is particularly suitable for this visualization because it clearly illustrates the proportion of users for each operating system within each age group. The different colors here perfectly distinguish two OS.

## Question 2:How does screen time vary by different age groups?
![](https://github.com/MagicalMT/STAT451-final-project/blob/main/p23.png)
In this plot, the x-axis represents the age of the user, and the y-axis shows the average screen usage time (in hours per day). The red and blue dots represent individual observations of screen usage time for females and males at different ages, respectively. Each dot indicates the average screen time for a specific gender at a particular age.In this plot, we use a smooth curve to display the overall trend to give audience a better and more intuitive comparison. We can observe a peak in screen usage time for males around 50 years old, while for females, there is a peak around 35 years old. Otherwise, the average screen usage time is similar for both genders. We use line plot here because it emphasizes the trend over ages groups

