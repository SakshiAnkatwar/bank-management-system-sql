

CREATE TABLE Customers (
    customerid INT PRIMARY KEY,
    customername VARCHAR(50),
    phoneno VARCHAR(50),
    city VARCHAR(50),
    accountType VARCHAR(50),
    AccountNo BIGINT
);
select * from customers ;

DROP TABLE customers ;
drop table loans;
drop table accounts ;
drop table transactions;

INSERT INTO customers
(CustomerID, CustomerName, PhoneNo, City, AccountType,accountno)
VALUES
(1, 'Rahul Sharma', '9876543210', 'Pune', 'Savings',1001),
(2, 'Sneha Patil', '9988776655', 'Mumbai', 'Current',1002),
(3, 'Aman Verma', '9123456780', 'Nagpur', 'Savings',1003),
(4, 'Priya Singh', '9012345678', 'Delhi', 'Current',1004),
(5, 'Karan Mehta', '9871203456', 'Hyderabad', 'Savings',1005),
(6, 'Neha Joshi', '9988001122', 'Pune', 'Current',1006),
(7, 'Rohit Kumar', '9765432109', 'Bangalore', 'Savings',1007),
(8, 'Pooja Sharma', '9876540001', 'Chennai', 'Savings',1008),
(9, 'Vivek Shah', '9001122334', 'Ahmedabad', 'Current',1009),
(10, 'Anjali Verma', '9988771100', 'Jaipur', 'Savings',1010);


CREATE TABLE accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    Balance DECIMAL(10,2),
    OpenDate DATE,
    FOREIGN KEY (Customerid) REFERENCES customers(Customerid)
);

INSERT INTO accounts
(AccountID, CustomerID, Balance, OpenDate)
VALUES
(1001, 1, 55000, '2025-01-10'),
(1002, 2, 120000, '2024-11-20'),
(1003, 3, 35000, '2025-03-15'),
(1004, 4, 98000, '2025-02-01'),
(1005, 5, 75000, '2025-01-25'),
(1006, 6, 150000, '2024-12-18'),
(1007, 7, 42000, '2025-04-10'),
(1008, 8, 88000, '2025-05-05'),
(1009, 9, 200000, '2024-09-30'),
(1010, 10, 67000, '2025-03-22');
select* from accounts;

CREATE TABLE transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(10,2),
    TransactionDate DATE,
    FOREIGN KEY (AccountID) REFERENCES accounts(AccountID)
);

INSERT INTO transactions
(TransactionID, AccountID, TransactionType, Amount, TransactionDate)
VALUES
(1, 1001, 'Deposit', 10000, '2026-06-01'),
(2, 1001, 'Withdraw', 5000, '2026-06-02'),
(3, 1002, 'Deposit', 25000, '2026-06-02'),
(4, 1003, 'Withdraw', 3000, '2026-06-03'),
(5, 1004, 'Deposit', 15000, '2026-06-04'),
(6, 1005, 'Deposit', 12000, '2026-06-05'),
(7, 1006, 'Withdraw', 7000, '2026-06-05'),
(8, 1007, 'Deposit', 9000, '2026-06-06'),
(9, 1008, 'Withdraw', 4500, '2026-06-06'),
(10, 1009, 'Deposit', 30000, '2026-06-07'),
(11, 1010, 'Withdraw', 2000, '2026-06-07'),
(12, 1002, 'Withdraw', 10000, '2026-06-08'),
(13, 1003, 'Deposit', 5000, '2026-06-08'),
(14, 1005, 'Withdraw', 3500, '2026-06-09'),
(15, 1007, 'Deposit', 15000, '2026-06-09');

select * from transactions;

CREATE TABLE loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount DECIMAL(12,2),
    LoanType VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

INSERT INTO loans
(LoanID, CustomerID, LoanAmount, LoanType)
VALUES
(1, 1, 500000, 'Home Loan'),
(2, 2, 200000, 'Car Loan'),
(3, 4, 100000, 'Education Loan'),
(4, 5, 300000, 'Business Loan'),
(5, 6, 150000, 'Personal Loan'),
(6, 8, 250000, 'Home Loan'),
(7, 9, 400000, 'Business Loan'),
(8, 10, 180000, 'Car Loan');

select * from customers ;
select * from accounts;
select * from transactions;
select* from loans;

--1. Display customer names, account numbers, and account balances using INNER JOIN.--
 select c.customerid,
    c.customername ,
	c.accountno,
	a.balance
	from customers c
	inner join accounts a
	on c .customerid=a.customerid;

--2. Find the top 3 customers with the highest account balances.--	
  select c.customerid,
    c.customername ,
	a.balance
	from customers c
	inner join accounts a
	on c .customerid=a.customerid
	order by a.balance  desc 
	limit 3;

--3. Show all customers who have taken loans along with loan amount and loan type--

 select c.customername ,
	l.loanamount,
	l.loantype
	from customers c
	inner join loans l
	on c .customerid=l.customerid ;

--4. Find the total deposited amount and total withdrawn amount separately
 select
    transactiontype,
    SUM(amount) as total_amount
 from transactions
 where  transactiontype in ('Deposit', 'Withdraw')
 group by transactiontype;

--5. Display customer-wise total transaction amount using GROUP BY.
 SELECT c.customerid,c.customername,
    SUM(t.amount) AS total_transactionamount
 FROM customers c inner join accounts a
 on c.customerid =a.customerid
 inner join transactions t
 on a.accountid =t.accountid
 GROUP BY c.customerid ,c.customername;

--6. Find customers whose balances are greater than the average bank balance.
 select  c.customername,
        c.customerid,
        a.balance
		from customers c 
		inner join accounts a
 on c.customerid=a.customerid
 where a.balance >( select avg(balance)
    FROM accounts );
	
	select * from transactions;
	
--7. Show the highest transaction amount performed by each customer.
 select  c.customerid,
       c.customername,
   max(t.amount) as highest_amount from customers c
  inner join accounts a
    on c.customerid = a.customerid
 inner join transactions t
    on a.accountid = t.accountid
 group by c.customerid, c.customername;


--8. Display all customers who have not taken any loans using LEFT JOIN
 select  c.customerid,
       c.customername
 from  customers c
 left join loans l
    on c.customerid = l.customerid
 where l.customerid is null;

--9. Find the total number of transactions performed by each customer
 select c.customerid,
        c.customername,
count(t.transactionid) as total_transaction
from  customers c
inner join accounts a
on c.customerid =a.customerid
inner  join transactions t 
on a.accountid =t.accountid
group by c.customerid, c. customername;

--10. Rank customers based on their account balances using RANK() window function
	 select c.customerid,
	        c.customername,
			a.balance,
 rank () over(order by a.balance asc)
 as balance_rank   
 from customers c 
 inner join accounts a
 on c.customerid=a.customerid;

--11. Display dense ranking of customers according to balance using DENSE_RANK().
 select c.customerid,
	        c.customername,
			a.balance,
 dense_rank () over(order by a.balance asc) 
 as rank_balance   
 from customers c inner join accounts a
 on c.customerid=a.customerid;

--12. Show previous transaction amount using LAG() function.
  select transactionid,
        accountid,
        amount,
  lag(amount) over ( partition by accountid
 	   order by transactionid
        ) as previous_amount
   from transactions;

--13. Show next transaction amount using LEAD() function
 select transactionid,
        accountid,
        amount,
 lead(amount) over (
           partition by accountid
 	   order by transactionid
        ) as upcoming_amount
  from transactions;

--14. Calculate running total of transaction amounts using SUM() OVER().
  select transactionid,
       amount,
       sum(amount) over (
           order by transactionid
        ) as running_total
   from transactions;
--15. Find the second highest account balance using subquery or window function.
  select  max (balance) as secondhighest_balance
  
--16. Find customers who performed more than 2 transactions
  select c.customerid,
       c.customername,
       count(t.accountid) as total_transactions
  from customers c
  right join accounts a
    on c.customerid = a.customerid
  right join transactions t
    on a.accountid = t.accountid
  group by c.customerid, c.customername
  having count(t.transactionid) > 2;

--17. Display customer-wise minimum and maximum transaction amounts.
 SELECT c.customerid,
       c.customername,
       MIN(t.amount) AS minimum_transaction,
       MAX(t.amount) AS maximum_transaction
 FROM customers c
 right JOIN accounts a
    ON c.customerid = a.customerid
  right JOIN transactions t
    ON a.accountid = t.accountid
  GROUP BY c.customerid, c.customername;