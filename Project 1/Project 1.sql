-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

/* rename all columns */


EXEC sp_RENAME 'aivanov.demographics.tri_age' , 'age', 'COLUMN'
EXEC sp_RENAME 'aivanov.demographics.GenderCode' , 'Gender', 'COLUMN'
EXEC sp_RENAME 'aivanov.demographics.ContactID' , 'ID', 'COLUMN'
EXEC sp_RENAME 'aivanov.demographics.Address1_Stateorprovince' , 'State', 'COLUMN'
EXEC sp_RENAME 'aivanov.demographics.Tri_ImagineCareenrollmentemailsentdate' , 'EmailSentdate', 'COLUMN'
EXEC sp_RENAME 'aivanov.demographics.Tri_enrollmentcompletedate' , 'Completedate', 'COLUMN'

/* calculate the time in datys to complete enrollment and create a new column */
alter table aivanov.demographics
add Actual_date_difference as datediff(dd,try_convert(date,Emailsentdate),try_convert(date,completedate))

SELECT TOP 10 * FROM aivanov.demographics
Where Actual_date_difference is NOT NULL
ORDER BY NEWID()  

/* create a new column and change values*/
alter table aivanov.demographics
add "Enrollment Status" varchar(255);

UPDATE aivanov.demographics
SET "Enrollment Status" = (
  CASE tri_imaginecareenrollmentstatus
    WHEN 167410011 THEN 'Complete'
    WHEN 167410001 THEN 'Email sent'
	WHEN 167410004 THEN 'Non responder'
	WHEN 167410005 THEN 'Facilitated Enrollment'
	WHEN 167410002 THEN 'Incomplete Enrolments'
	WHEN 167410003 THEN 'Opted Out'
	WHEN 167410000 THEN 'Unprocessed'
	WHEN 167410006 THEN 'Second email sent'
  END
)
WHERE tri_imaginecareenrollmentstatus IN (167410011,167410001,167410004,167410005,167410002,167410003,167410000,167410006);

SELECT TOP 10 * FROM aivanov.demographics
Where Actual_date_difference is NOT NULL
ORDER BY NEWID()

/*create new column and make conditional values */
alter table aivanov.demographics
add "Sex" varchar(255);

UPDATE aivanov.demographics
SET "Sex" = (
  CASE Gender
    WHEN '2' THEN 'female'
    WHEN '1' THEN 'male'
	WHEN '167410000' THEN 'other'
	WHEN 'NULL' THEN 'Unknown'
  END
)
WHERE Gender IN ('2','1','167410000','NULL');

SELECT TOP 10 * FROM aivanov.demographics
Where Actual_date_difference is NOT NULL
ORDER BY NEWID()  

/* bin ages in a new column called age group */

alter table aivanov.demographics
add "Age group" varchar(255);

/* To check the highest age to make bins for */
Select max(age) from aivanov.demographics

UPDATE aivanov.demographics
SET "Age Group" = CASE
WHEN age between 0 AND 25 THEN '0-25' 
WHEN age BETWEEN 26 AND 50 THEN '26-50'
WHEN age BETWEEN 51 AND 75 THEN '51-75'
WHEN age BETWEEN 76 AND 100 THEN '76-100'
END

SELECT TOP 10 * FROM aivanov.demographics
Where Actual_date_difference is NOT NULL
ORDER BY NEWID()  


