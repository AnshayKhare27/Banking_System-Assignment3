--Tasks 1: Database Design:  

--1. Create the database named "HMBank"  
create database HMBank;
use HMBank;

--2. Define the schema for the Customers, Accounts, and Transactions tables based on the provided schema.
create table Customers(
customer_id INT IDENTITY PRIMARY KEY,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
DOB VARCHAR(10) NOT NULL,
email VARCHAR(30) NOT NULL,
phone_number VARCHAR(10) NOT NULL,
address VARCHAR(30) NOT NULL);

INSERT INTO Customers(first_name, last_name, DOB, email, phone_number, address)
VALUES
    ('John', 'Doe', '1990-01-01', 'johndoe@example.com', '1234567890', '123 Main St'),
    ('Jane', 'Smith', '1995-02-02', 'janesmith@example.com', '9876543210', '456 Main St'),
    ('Alice', 'Johnson', '1985-03-03', 'alicejohnson@example.com', '5678901234', '789 Main St'),
    ('Bob', 'Williams', '1970-04-04', 'bobwilliams@example.com', '4567890123', '101 Main St'),
    ('Charlie', 'Brown', '1965-05-05', 'charliebrown@example.com', '3456789012', '102 Main St'),
    ('David', 'Lee', '1950-06-06', 'davidlee@example.com', '2345678901', '103 Main St'),
    ('Emily', 'Wilson', '1945-07-07', 'emilywilson@example.com', '1234567890', '104 Main St'),
    ('Frank', 'Taylor', '1940-08-08', 'franktaylor@example.com', '9876543210', '105 Main St'),
    ('Grace', 'Miller', '1935-09-09', 'gracemiller@example.com', '5678901234', '106 Main St'),
    ('Henry', 'Baker', '1930-10-10', 'henrybaker@example.com', '4567890123', '107 Main St');

select * FROM Customers;

create table Accounts(
account_id INT IDENTITY PRIMARY KEY,
customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
account_type VARCHAR(15) NOT NULL,
balance INT);

INSERT INTO Accounts (customer_id, account_type, balance)
VALUES
    (1, 'Savings', 1000),
    (1, 'Current', 500),
    (2, 'Savings', 2000),
    (3, 'Current', 1500),
    (4, 'Savings', 3000),
    (4, 'Current', 2500),
    (6, 'Savings', 4000),
    (7, 'Current', 3500),
    (7, 'Savings', 5000),
    (9, 'Current', 4500);

select * FROM Accounts;

create table Transactions(
transaction_id INT IDENTITY PRIMARY KEY,
account_id INT FOREIGN KEY REFERENCES Accounts(account_id),
transaction_type VARCHAR(15) NOT NULL,
amount INT,
transaction_date VARCHAR(10) NOT NULL);

INSERT INTO Transactions (account_id, transaction_type, amount, transaction_date)
VALUES
    (1, 'Deposit', 500.00, '2024-09-01'),
    (1, 'Withdrawal', 200.00, '2024-09-02'),
    (2, 'Deposit', 1000.00, '2024-09-03'),
    (2, 'Withdrawal', 500.00, '2024-09-04'),
    (2, 'Deposit', 1500.00, '2024-09-05'),
    (3, 'Withdrawal', 750.00, '2024-09-06'),
    (4, 'Deposit', 2000.00, '2024-09-07'),
    (7, 'Withdrawal', 1000.00, '2024-09-08'),
    (9, 'Deposit', 2500.00, '2024-09-09'),
    (9, 'Withdrawal', 1250.00, '2024-09-10');

select * FROM Transactions;

--TASK 2
-- Write SQL queries for the following tasks: 
--1. Write a SQL query to retrieve the name, account type and email of all customers.  
select Customers.first_name, Accounts.account_type, Customers.email From Customers left join Accounts ON Customers.customer_id = Accounts.customer_id;

--2. Write a SQL query to list all transaction corresponding customer. 
select Customers.first_name, Transactions.transaction_type, Transactions.amount, Transactions.transaction_date 
From Transactions left join Accounts ON Transactions.account_id = Accounts.account_id 
left join Customers ON Customers.customer_id = Accounts.customer_id;

--3. Write a SQL query to increase the balance of a specific account by a certain amount. 
update Accounts
set balance = balance + 2000
where account_id = 4;

--4. Write a SQL query to Combine first and last names of customers as a full_name. 
select CONCAT(Customers.first_name, ' ', Customers.last_name) As full_name
from Customers

--5. Write a SQL query to remove accounts with a balance of zero where the account type is savings. 
delete from Accounts where balance=0 and account_type='Saving';

--6. Write a SQL query to Find customers living in a specific city. 
--In our data enteries, assming customers with address (100 Main st. - 109 Main st.) are residing in same city
select * From Customers
where address like '10_ Main St';

--7. Write a SQL query to Get the account balance for a specific account. 
select account_id, balance From Accounts
where account_id = 5;

--8. Write a SQL query to List all current accounts with a balance greater than $1,000.
select * From Accounts
where balance>1000;

--9. Write a SQL query to Retrieve all transactions for a specific account. 
select * from Transactions
where account_id= 2;

--10. Write a SQL query to Calculate the interest accrued on savings accounts based on a given interest rate.
declare @rate int = 5;
select *,((balance * @rate)/100) AS Interest from Accounts

--11. Write a SQL query to Identify accounts where the balance is less than a specified overdraft limit.
declare @overdraft_limit int = 2600;
select * From Accounts
where balance<@overdraft_limit;

--12. Write a SQL query to Find customers not living in a specific city. 
--In our data enteries, assming customers with address (100 Main st. - 109 Main st.) are residing in same city
select * From Customers
where address not like '10_ Main St';


--TASK 3
--1. Write a SQL query to Find the average account balance for all customers. 
select customer_id ,AVG(balance) AS "Average Balance" from Accounts
group by customer_id;

--2. Write a SQL query to Retrieve the top 10 highest account balances. 
select top 10 customer_id, balance from Accounts
order by balance desc;

--3. Write a SQL query to Calculate Total Deposits for All Customers in specific date.
declare @transactionDate Varchar(10) = '2024-09-09';
select SUM(amount) AS TOTAL_DEPOSIT from Transactions
where transaction_type = 'Deposit' and transaction_date = @transactionDate;

--4. Write a SQL query to Find the Oldest and Newest Customers. 
--Query to find oldest customer
select top 1 * from Customers
order by DOB;
--Query to find newest/youngest customer
select top 1 * from Customers
order by DOB desc;

--5. Write a SQL query to Retrieve transaction details along with the account type. 
select t.*,a.account_type from Transactions t left join Accounts a
On t.account_id = a.account_id;

--6. Write a SQL query to Get a list of customers along with their account details. 
select c.first_name, c.last_name, a.* from Accounts a left join Customers c
on a.customer_id = c.customer_id;

--7. Write a SQL query to Retrieve transaction details along with customer information for a specific account. 
select t.*,c.email,c.phone_number from Transactions t left join Accounts a on t.account_id = a.account_id
left join Customers c on a.customer_id = c.customer_id
where a.account_id = 2;

--8. Write a SQL query to Identify customers who have more than one account. 
SELECT c.customer_id, c.first_name, c.last_name, COUNT(c.customer_id) AS account_count
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(c.customer_id) > 1;

--9. Write a SQL query to Calculate the difference in transaction amounts between deposits and withdrawals. 
select (
       (select sum(amount) from Transactions where transaction_type = 'Deposit') - (select sum(amount) from Transactions where transaction_type = 'Withdrawal')
) AS total_difference

--10. Write a SQL query to Calculate the average daily balance for each account over a specified period. 
declare @days int = 20;
select *, (balance/@days) AS avg_daily_balance From Accounts;

--11. Calculate the total balance for each account type. 
select account_type, sum(balance) as total_balance from Accounts
group by account_type

--12. Identify accounts with the highest number of transactions order by descending order.
select account_id, COUNT(account_id) as 'No. of transactions' from Transactions
group by account_id
order by COUNT(account_id) desc;


--13. List customers with high aggregate account balances, along with their account types.
declare @highBalance int = 2000;
select customer_id,balance,account_type from Accounts
where balance>@highBalance;

--14. Identify and list duplicate transactions based on transaction amount, date, and account. 
select distinct account_id, amount, transaction_date from Transactions
group by account_id, amount, transaction_date
Having COUNT(*)>1;

--TASK 4
--1. Retrieve the customer(s) with the highest account balance. 
select * from Accounts
where balance = (select MAX(balance) from Accounts);

--2. Calculate the average account balance for customers who have more than one account. 
select customer_id, AVG(balance) from Accounts
group by customer_id
having COUNT(customer_id)>1;

--3. Retrieve accounts with transactions whose amounts exceed the average transaction amount. 
select * from Transactions
where amount> (select AVG(amount) from Transactions)

--4. Identify customers who have no recorded transactions. 
select a.customer_id from Accounts a left join Transactions t 
on a.account_id = t.account_id
group by t.account_id,a.customer_id
having COUNT(t.account_id) = 0;

--5. Calculate the total balance of accounts with no recorded transactions.
select a.customer_id,a.balance from Accounts a left join Transactions t 
on a.account_id = t.account_id
group by t.account_id,a.customer_id,a.balance
having COUNT(t.account_id) = 0;

--6. Retrieve transactions for accounts with the lowest balance. 
select t.* from Transactions t join Accounts a
on t.account_id = a.account_id
where a.balance = (select MIN(balance) from Accounts)

--7. Identify customers who have accounts of multiple types. 
select customer_id from Accounts
group by customer_id
having COUNT(customer_id)>1

--8. Calculate the percentage of each account type out of the total number of accounts.
select account_type, (((COUNT(account_type)*100)/(select COUNT(account_id) from Accounts))) AS percentage from Accounts
group by account_type


--9. Retrieve all transactions for a customer with a given customer_id.
declare @customerID int = 1;
select c.customer_id,t.* from Transactions t join Accounts a on a.account_id = t.account_id
join Customers c on c.customer_id = a.customer_id
where c.customer_id= @customerID;

--10. Calculate the total balance for each account type, including a subquery within the SELECT clause.
select account_type,SUM(balance) from Accounts
group by account_type