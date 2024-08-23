# Google-Data-Analytics-Capstone-Project-How-does-a-bike-share-navigate-speedy-success-

Google Data Analytics Capstone Project: How does a bike-share navigate speedy success?
Scenario
I am a junior data analyst working on the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.
Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth.
Rather than creating a marketing campaign that targets all-new customers, the marketing director believes there is a solid opportunity to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.
The marketing director has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. To do that, however, the team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.
Among the various aspects to analyze, I have been assigned to answer the following question: How do annual subscribers use our bicycles compared to casual users?
 
I was asked to produce a report with the following deliverables:
You will produce a report with the following deliverables:
1. A clear statement of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of your analysis
5. Supporting visualizations and key findings
6. Your top three recommendations based on your analysis
 
Business Task
Compare both casual and members usage patterns in other to gain insights. The main goal is to implement a business strategy to convert casual users into members.
Data Sources
Use Cyclistic’s historical trip data to analyze and identify trends. This is public data that you can use to explore how different customer types are using Cyclistic bikes. In this case, I will analyzing the last twelve months from Aug-23 to Jul-24.
It’s important to keep in mind that due to data-privacy issues, we cannot access riders’ personally identifiable information. This means that I won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.
Data Manipulation
For this case study, I’ll be using BigQuery due to the size of the files and SQL to perform queries. 
The reason for this is the size of the 12 files (roughly 700 mb). After combining all of them, the resulting csv file has more than 5 million rows which make impossible using Excel due to its limitations. 
All SQL queries corresponding to each step of the manipulation are included in the attached notebook.
Data Merging
I’ve combined all last twelve months into one single dataset: `23_24_bikeshare_data`. The resulting dataset has 5715693 rows.
 
Data Exploration
Columns name and data types:
 
	Null values per each column:
 

Columns “end_lat”, “end_lng”, “end_station_id”, “end_station_name”, “start_station_id” and “start_station_name” have null values which will be deleted in the cleaning section

Duplicate values
 
Also, there are 211 duplicate trip (values with the same ride_id nº) which will be deleted from our dataset.
	Rideable Types
 
There are three types of bikes: Electric, Classic and Docked. After checking with the operations department, docked and classic are basically the same type of bike so we will rename “docked_bike” as “classic bike” in the next section.
started_at and ended_at (datetime columns)
both columns in datetime format (UTC). I’ve used both dates to create the ride_length column. I’ve found out there are 8001 trips longer than a day and 131281 trips below 1 minute.
 
Those trips will not be considered for this case of study and will be deleted from our dataset
Member / Casual riders
We found only two types of users:
 
Data Cleaning
 To create our clean dataset, I’ve followed these steps:
1.	Clean all null values from the columns “end_lat”, “end_lng”, “start_lat”, “start_lng”, “start_station_id”, “end_station_id” and “start_station_name”.
2.	Rename “docked_bikes” as “classic_bikes”
3.	Create the “ride_length column and delete trips longer than a day and shorter than a day
4.	Delete duplicated values
5.	Delete the “start_station_id” and “end_station_id” columns
6.	Once performed all the above steps I’ve created a new table called `23_24_bikeshare_data_clean` in Google Big Query. We can now start with the analysis. For visualizations, I’m using Power BI.

Data Analysis
I have conducted a comparative analysis of the different usage patterns based on the day of the week, time of day, season of the year, and start & end stations. For visualizations, I’ve used Power BI
General considerations
First of all, let's take a look at how many users we have, and what percentage is represented by member and casual users: 
As we can see on the pie chart below, roughly the 65% of the trips performed during the past 12 months were made by subscribers of our service whilst the remaining 35% of the trips were made by casual users.
We can also see the same proportion in the use of classic and electric bicycles. The classic bike is the most used bicycle by both casual users and members on their trips: 
 
 
Usage patterns
     
As we can see on the above plots, members use bikes mostly from Monday to Friday and the peaks of rentals take place at 8:00 am and 17:00 pm which matches the standard working start and end hours. 
On the other hand, casual users daily peak of usage takes place on the weekend (Saturdays) and the usage increases constantly during the day. The hour usage peak takes place also in the afternoon although not as pronounced compared to the members. 
During our analysis we were also able to conclude the time of the year has a direct impact in the habits of both members and casual users, not only in terms of number of trips but in the average trip duration:
 
 
The time of the year has a direct impact on the number of rentals and trips made by both member and casual users increase significantly in the Summer.
However, whilst member’s average trip length is roughly 10 min and remains almost unchanged throughout the entire year, casual users average trip varies significantly ranging from 15 minutes in January to 28 minutes in July. In general terms, the casual average trip length exceeds by far the yearly average trip (18 min approx.), especially from May to September.
 
 For last, I have been able to confirm that members and casual users use bicycles to commute to or from very different areas.
 

The most common starting and ending stations of casual users are primarily located in green areas such as Millenium Park, along by the lakefront boardwalk, DuSable Harbor or Shedd Aquarium amongst others. Member, on the other side, start and end their trips in station located near university areas such a Ellis Ave & 60th St or State St & 33rd St and University apartment areas such as Loomis St & Lexington St.
Conclusions
Based on the above analysis I was able to conclude that, in general terms, there are two types of users with two well-differentiated profiles: 
•	Members primarily use our service as a transportation mean to commute from/to work or college during weekdays, taking specific routes with a set duration. 
•	Casual users, on the other hand, use the service to explore the city's green areas and sightseeing especially on weekends and in the afternoon, with longer durations since they don't just don’t travel exclusively from point A to point B.
Actions
I recommend undertaking the following actions: 
•	Summer Recruitment Campaign: We have observed that in summer, the number of trips made by casual users increases significantly, so it would be interesting to launch some sort of welcome offer with a substantial discount during the summer months.
•	Weekend Passes: Another action to consider would be creating a special pass for the weekend, aimed at retaining users who use the bicycle exclusively for leisurely rides in the city's green areas.
•	Passes for Specific Routes: In line with the previous point, it would be worth considering a pass for certain popular routes, such as the lakefront or parks.
