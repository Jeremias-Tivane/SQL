

--======================Lesson 5, SQL Data Cleaning

--======================LEFT & RIGHT Quizzes

--1.In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(WEBSITE, 3) WEB_DOMINE, COUNT(*) COUNT_WEB_DOMINE
FROM ACCOUNTS
GROUP BY 1
ORDER BY 1;

--2.There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(UPPER(NAME), 1) COMP_NAME, COUNT(*) NUM_COMPANIES
FROM ACCOUNTS 
GROUP BY 1
ORDER BY 2 DESC;

--3.Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

--4.Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                        THEN 1 ELSE 0 END AS vowels, 
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;

--======================CONCAT QUIZ

--1.Use the accounts table to create first and last name columns that hold the first and last names for the PRIMARY_POC.

SELECT NAME,
LEFT(PRIMARY_POC, STRPOS(PRIMARY_POC, ' ') -1 ) FIRST_NAME, 
RIGHT(PRIMARY_POC, LENGTH(PRIMARY_POC) - STRPOS(PRIMARY_POC, ' ')) LAST_NAME
FROM ACCOUNTS;


--2.Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.

SELECT NAME,
LEFT(NAME, STRPOS(NAME, ' ') -1) AS FIRST_NAME,
RIGHT(NAME, LENGTH(NAME) - STRPOS (NAME, ' ')) AS LAST_NAME
FROM SALES_REPS


--======================POSITION, STRPOS, & SUBSTR - AME DATA AS QUIZ

--1.Each company in the accounts table wants to create an email address for each PRIMARY_POC. The email address should be the first name of the PRIMARY_POC . last name PRIMARY_POC @ company name .com.
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
 
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

--OR

WITH t1 AS ( SELECT WEBSITE, PRIMARY_POC, NAME,
 LEFT(PRIMARY_POC, STRPOS(PRIMARY_POC, ' ') -1 ) FIRST_NAME, 
 RIGHT(PRIMARY_POC, LENGTH(PRIMARY_POC) - STRPOS(PRIMARY_POC, ' ')) LAST_NAME
 FROM accounts)
 
SELECT PRIMARY_POC, WEBSITE, FIRST_NAME || '.' || LAST_NAME || '@' || RIGHT(WEBSITE, -4) AS EMAIL_ADRESS
FROM t1;

--2.You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

--3.We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the PRIMARY_POC's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name, 
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), 
LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') AS PASSWORD
FROM t1;

--======================CAST, QUIZ

--1.Write a query to change the date into the correct SQL date format. you will need to use at least SUBSTR and CONCAT to perform this operation.
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

--2.Once you created a column in the corrwct format, use either CAST or :: to convert this to a date.
--PS:Notice, this new date can be operated on using DATE_TRUNC and DATE_PART in the same way as earlier lessons.

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

--======================CAST, QUIZ
--1. Run the query entered below in the SQL workspace row with missing data.
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

--2. Use COALESCE to fill in the accounts.id column with the account.id for the NULL value for the table in 1 .
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

--3. Use COALESCE to fill in the orders.account_id column with the account.id for the NULL value for the table in 1 .
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

--4. Use COALESCE to fill in each of the qty and usd column with 0 for the table in 1.
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

--5. Run the query in 1 with the WHERE removed and Count the number of id s.
SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

--6. Run the query in 5, but with the COALESCE function questions 2 through 4.
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;


--======================END (Jeremias Tivane - https://www.linkedin.com/in/jeremiastivane )


