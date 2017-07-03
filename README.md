# SQL-Development

This database uses stored procedure, triggers, views, users, roles and
permission. All the concepts of SQL server have been made use of in this project to attain
maximum efficiency. 

A brief description about each concept used:
Stored procedure:
 - WorkHoursAndEEOCTracking – To calculate the regular hours and overtime
hours to keep track of the project’s EEOC requirement.
 - NetWeeklyPay – To calculate weekly pay of an employee after tax deductions.

Views: Exhibit B is achieved by creating views for each Job classification.

Trigger: PayScaleTrigger is used to update the Overtime pay rate which is 1.5 times basic
pay rate

User: Database access is given only to the user “sa”.

Permission: The user is given permission to create, read, write and update database.