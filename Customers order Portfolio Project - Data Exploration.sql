-- Find employees who work at ‘UK’ offices.
Select lastName,firstName from employees e join offices o
on e.officeCode = o.officeCode
where country = "UK";


-- Find customers whose payments are greater than the average payment
select * from payments
where amount > (select AVG(amount) from payments);



-- Find the customers who have not placed any orders
select * from customers c left join payments p on c.customerNumber = p.customerNumber
where p.customerNumber is null;    



-- Find customers who lived in California state of USA country.
SELECT customerName, contactLastName, contactFirstName, phone, country, state FROM customers
WHERE state = "CA" AND country = "USA";



-- Top 5 employees(firstName, lastName, phone, city) sales products in 2005.

With top_sale as(
SELECT sum(od.quantityOrdered*od.priceEach) as topsale,c.salesRepEmployeeNumber from orderdetails od, customers c, orders o
where o.orderNumber = od.orderNumber
AND c.customerNumber = o.customerNumber
AND YEAR(shippedDate) = "2005"
AND status = "shipped"
group by salesRepEmployeeNumber
order by topsale DESC
limit 5
)
SELECT firstName, lastName FROM employees, top_sale
where employeeNumber = salesRepEmployeeNumber;



-- Select the total sales by month in 2004.

SELECT sum(od.quantityOrdered*od.priceEach) as totalsale, month(orderDate) as month_order  from orderdetails od, orders o
where o.orderNumber = od.orderNumber
AND YEAR(orderDate) = "2004"
AND status = "shipped"
group by 2;



-- Select the total sales of the years after 2003.

SELECT sum(od.quantityOrdered*od.priceEach) as totalsale, year(orderDate) as year_order  from orderdetails od, orders o
where o.orderNumber = od.orderNumber
AND orderDate>='2004-01-01'
AND status = "shipped"
group by 2;



-- Calculate the average value of each order and rounded DOWN to the nearest integer.

WITH totalorder AS(
SELECT orderNumber, SUM(quantityOrdered * priceEach) AS total
FROM orderdetails
GROUP BY orderNumber
)



SELECT FLOOR(AVG(total)) avg_total FROM totalorder;

-- Calculate the average value of each order and rounded UP to the nearest integer.
WITH totalorder AS(
SELECT orderNumber, SUM(quantityOrdered * priceEach) AS total
FROM orderdetails
GROUP BY orderNumber
)

SELECT CEIL(AVG(total)) avg_total FROM totalorder;



-- Find the top three products by product line that have the highest inventory

With inventory as (
SELECT productCode,productLine, quantityInStock,productName,
ROW_NUMBER () OVER(PARTITION BY productLine order by quantityInStock desc ) AS rownumber
FROM products
 )
 
 select productLine, productCode, productName, quantityInStock from inventory
 where rownumber <=3;



-- Show customers who have total values of orders by year in descending order.

with total_value_by_year as(
SELECT year(orderDate) as year_oder,customerNumber,sum(priceEach*quantityOrdered) as totalvalue
from orderdetails od, orders o
where o.orderNumber = od.orderNumber
group by 1,2
)
select year_oder,customerName, totalvalue,
row_number() over (partition by year_oder order by totalvalue DESC) row_num
from total_value_by_year tv join customers c on tv.customerNumber = c.customerNumber
