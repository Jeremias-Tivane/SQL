
--======================Lesson 6, [Advanced] SQL Window Functions

--==============FULL OUTER JOIN

--==============Example1: Finding Matched and Unmatched Rows with FULL OUTER JOIN

--Say you're an analyst at Parch & Posey and you want to see:
--1. each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
--2. but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)

SELECT * 
FROM
accounts A FULL OUTER JOIN sales_reps S
ON A.sales_rep_id = S.ID

--> If unmatched rows existed (they don't for this query), you could isolate them by adding the following line to the end of the query:

--WHERE A.sales_rep_id IS NULL OR S.id IS NULL;


--=====Example1: JOINs with Comparison Operators

--3. write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so: accounts.primary_poc < sales_reps.name

SELECT A.name as account_name,
       A.primary_poc as poc_name,
       S.name as sales_rep_name
  FROM accounts A
  LEFT JOIN sales_reps S
    ON A.sales_rep_id = S.id
   AND A.primary_poc < S.name

--=====Example2: Self JOINs

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at

--==============Appending Data via UNION

--=====Example3: Appending Data via UNION

--4. Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.
SELECT *
    FROM ACCOUNTS
UNION ALL
SELECT *
  FROM ACCOUNTS
  
--=====Example4: Pretreating Tables before doing a UNION

--5. Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney. Inspect the results then answer the subsequent quiz.
SELECT *
    FROM ACCOUNTS
    WHERE NAME = 'Walmart'
UNION ALL
SELECT *
  FROM ACCOUNTS
  WHERE NAME = 'Disney'

--=====Example4: Performing Operations on a Combined Dataset

--6. Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name.

WITH Double_Accounts AS (
    SELECT *
      FROM ACCOUNTS
    UNION ALL
    SELECT *
      FROM ACCOUNTS
)
SELECT NAME,
       COUNT(*) AS Name_Count
 FROM Double_Accounts 
GROUP BY 1
ORDER BY 2 DESC


--==============JOINing Subqueries to Improve Performance

SELECT o.occurred_at AS date,
       a.sales_rep_id,
       o.id AS order_id,
       we.id AS web_event_id
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
ORDER BY 1 DESC


--======================END (Jeremias Tivane - https://www.linkedin.com/in/jeremiastivane )


