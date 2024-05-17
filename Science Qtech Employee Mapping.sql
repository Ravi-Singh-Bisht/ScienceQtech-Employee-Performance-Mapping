# 1)Create a Database named Employee then import data_science,emp_record,project 
USE science_qtech;

# 2) Create ER Diagram
ALter table emp_record
Modify EMP_ID Varchar(20),
Add Primary Key (EMP_ID);

Alter table project
Rename Column Project_ID to Proj_ID;

Alter Table Project
Modify Proj_ID Varchar(20);

ALter Table Data_Science
Modify EMP_ID Varchar(20);

Alter table Project 
Add Primary Key (Proj_ID);

Select Distinct Proj_ID From Emp_Record;
Update emp_record
Set Proj_ID =Null
Where Proj_ID = '';


ALter Table EMp_Record
Modify Proj_ID Varchar(20),
Add Foreign Key (Proj_ID) References project(Proj_ID);

Alter table data_science
Add Foreign Key (EMP_ID) references emp_record(EMP_ID);

Alter Table Project
Drop Column MyUnknownColumn;

CREATE TABLE `proj_table` (                           -- Create Similiar Table as Project as Project Table Showing Some Unnessary Column
  `Proj_ID` varchar(20) NOT NULL,
  `PROJ_NAME` text,
  `DOMAIN` text,
  `START _DATE` text,
  `CLOSURE_DATE` text,
  `DEV_QTR` text,
  `STATUS` text,
  PRIMARY KEY (`Proj_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Describe project;

Insert Into Proj_Table
Select Proj_ID,Proj_Name,Domain,`Start _Date`,Closure_Date,Dev_QTR,Status from Project;

# 3)Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
-- and make a list of employees and details of their department.
Select EMP_ID,First_Name,Last_Name,Gender,Dept from Emp_Record;

# 4.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
-- less than two
-- greater than four 
-- between two and four

Select EMP_ID,First_Name,Last_Name,Gender,Dept,EMp_Rating from EMP_REcord
Where EMp_RaTing<2;
Select EMP_ID,First_Name,Last_Name,Gender,Dept,EMp_Rating from EMP_REcord
Where EMp_RaTing>4;
Select EMP_ID,First_Name,Last_Name,Gender,Dept,EMp_Rating from EMP_REcord
Where EMp_RaTing between 2 and 4;

# 5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
-- from the employee table and then give the resultant column alias as NAME.

Select Concat(First_name,'',last_name) as `NAME` from EMP_RECORD
WHERE DEPT = 'Finance';

# 6.Write a query to list only those employees who have someone reporting to them. 
-- Also, show the number of reporters (including the President).

Select Distinct Manager_ID From EMP_RECORD;
Select X.Manager_ID,Y.First_Name,Y.Last_Name,COUNT(X.Manager_ID) as Person_Reporting_Them from 
Emp_Record as X Join EMP_RECORD as Y
on X.Manager_ID = Y.EMP_ID
Group BY Y.EMP_ID;

# 7.Write a query to list down all the employees from the healthcare and finance departments using union.
-- Take data from the employee record table.

Select * from EMP_RECORD
WHERE DEPT= 'Healthcare'
UNION
Select * from EMP_RECORD
WHERE DEPT= 'FINANCE';

# 8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
-- Also include the respective employee rating along with the max emp rating for the department.

Select EMP_ID,First_Name,Last_Name,Role,Dept,EMp_Rating,
MAX(EMP_Rating) over (Partition By DEPT) as MAX_Rating_DEPT from EMP_REcord;

# 9.Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

Select `ROLE` ,MAX(SALARY) ,MIN(SALARY) from EMP_RECORD
Group By ROLE;

# 10.Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

Select First_Name,Last_Name,Role,Exp,
Dense_Rank() Over (Order By Exp Desc) as `Rank` from EMP_RECORD; 

# 11.Write a query to create a view that displays employees in various countries whose salary is more than six thousand.
-- Take data from the employee record table.

Create View EMP_Country as
(Select First_Name,last_name,Country,Salary from EMP_RECORD
WHere Salary>6000);
Select * from EMP_COUNTRY;

# 12.Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

Select First_Name,Last_Name,Exp from Emp_Record
Where EXP In (Select EXP from EMp_record Where Exp>10);

# 13.Write a query to create a stored procedure to retrieve the details of the employees 
-- whose experience is more than three years. Take data from the employee record table.

Delimiter $$
Create Procedure EXP_More_10 ()
Begin
Select * from EMP_REcord
Where EXp>3; 
END $$

Delimiter ;
Call Exp_more_10;

# 14.Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
-- The standard being:
-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
-- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
-- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
-- For an employee with the experience of 12 to 16 years assign 'MANAGER'.

Delimiter $$
Create Function Job_Profile (Exp int)
Returns Varchar(30)
Deterministic
Begin
Declare Job_Profile Varchar(30);
If Exp<=2 then
Set Job_Profile = 'Junior Data Scientist';
ElseIf Exp>2 and Exp<=5 then
Set Job_Profile = 'Associate Data Scientist';
ElseIf Exp>5 and Exp<=10 then
Set Job_Profile = 'Senior Data Scientist';
ElseIf Exp>10 and Exp<=12 then
Set Job_Profile = 'Lead Data Scientist';
Elseif Exp>12 and Exp<=16 then
Set Job_Profile = 'Manager';
ENd iF;
Return (Job_Profile);

End $$

Delimiter ;
Select *,Job_Profile(`Exp`) from Data_Science;

# 15.Create an index to improve the cost and performance of the query to find the employee
-- whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

Create Index First_Name on emp_record(First_Name(20));
Select * from emp_record
Where First_name = "Eric";

Drop Index IdX_First_Name on emp_record_table;  -- Methof for Drop Index

# 16.Write a query to calculate the bonus for all the employees, based on their ratings and 
-- salaries (Use the formula: 5% of salary * employee rating).

Select First_Name,last_Name,Emp_Rating,Salary ,(Salary *0.05 *Emp_Rating) as Bonus from Emp_Record;

# 17.Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

Select Distinct Continent ,
Avg(Salary) Over (Partition by Continent) as AVG_SALARY_CONTINENT,Country,
Avg(Salary) Over (Partition by Country) as AVG_SALARY_COUNTRY
From EMP_Record;
