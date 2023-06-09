
select vt.make	



SELECT
    d.business_name,
    e.first_name,
    e.last_name,
    v.floor_price
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON e.employee_id = de.employee_id
INNER JOIN sales s ON s.employee_id = e.employee_id
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id;


with 
	most_sales as (
	select 
		s.sale_id,
		s.dealership_id,
		s.employee_id,
	count(s.sale_id) num_of_sales
	from sales s

join dealerships d 
	on d.dealership_id = s.dealership_id 
	)
	
	
with top_5_dealerships as 
(
	select dealership_id, COUNT(sale_id) as num_sales, sale_returned
	from sales s
	where sale sale_returned = 'false'
	group by employee_id, dealership_id, sale_returned 
	order by num_sales desc 
	limit 5
),

top_employee_sales as 
(
	select employee_id, Count(sale_id) as num_sales, dealership_id
	from sales s
	where sale_returned = 'false'
	group by employee_id, dealership_id 
	order by num_sales desc 
)

select td.dealership_id, ts.employee_id
from top_5_dealerships td
join top_employee_sales ts on td.dealership_id = ts.dealership_id



select distinct
	employees.last_name || ', ' || employees.first_name employee_name,
	sales.employee_id,
	sum(sales.price) over() total_sales,
	sum(sales.price) over(partition by employees.employee_id) total_employee_sales
from
	employees
join
	sales
on
	sales.employee_id = employees.employee_id
order by employee_name



--Write a query that shows the total purchase sales income per dealership.
SELECT s.dealership_id, SUM(s.price) AS dealership_purchase_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
where s.sales_type_id = '1'
GROUP BY s.dealership_id



--Write a query that shows the purchase sales income per dealership for July of 2020.
SELECT s.dealership_id, SUM(s.price) AS 2020_dealership_prchase_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
WHERE purchase_date BETWEEN '2020-07-01' AND '2020-07-30'
GROUP BY s.dealership_id



--Write a query that shows the purchase sales income per dealership for all of 2020.
SELECT s.dealership_id, SUM(s.price) AS purchase_dealership_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
join salestypes st on s.sales_type_id = st.sales_type_id 
WHERE s.sales_type_id= '1' and purchase_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY s.dealership_id
order by purchase_dealership_sales desc 


--Lease Income by Dealership
--Write a query that shows the total lease income per dealership.
SELECT s.dealership_id, SUM(s.price) AS dealership_purchase_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
WHERE s.sales_type_id= '2'
GROUP BY s.dealership_id


--Write a query that shows the lease income per dealership for Jan of 2020.
SELECT s.dealership_id, SUM(s.price) AS dealership_lease_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
join salestypes st on s.sales_type_id = st.sales_type_id 
WHERE s.sales_type_id= '2' and purchase_date BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY s.dealership_id
order by purchase_dealership_sales desc 


--Write a query that shows the lease income per dealership for all of 2019.
SELECT s.dealership_id, SUM(s.price) AS dealership_lease_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id 
join salestypes st on s.sales_type_id = st.sales_type_id 
WHERE s.sales_type_id= '2' and purchase_date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY s.dealership_id
order by dealership_lease_sales desc 


--Total Income by Employee
--Write a query that shows the total income (purchase and lease) per employee.


--Which model of vehicle has the lowest current inventory?

SELECT v.vehicle_type_id, vt.model, COUNT(v.vehicle_type_id) AS model_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
GROUP BY v.vehicle_type_id, vt.model
ORDER BY model_count ASC;


--Which model of vehicle has the highest current inventory? 
SELECT v.vehicle_type_id, vt.model, COUNT(v.vehicle_type_id) AS model_count
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id 
GROUP BY v.vehicle_type_id, vt.model
ORDER BY model_count desc;


--Which dealerships are currently selling the least number of vehicle models? 
SELECT d.business_name, s.dealership_id , COUNT(s.dealership_id) AS dealership_sales_count
FROM sales s
JOIN dealerships d on d.dealership_id = s.dealership_id 
GROUP BY d.business_name , s.dealership_id 
ORDER BY dealership_sales_count asc;


--Which dealerships are currently selling the highest number of vehicle models? 
SELECT d.business_name, s.dealership_id , COUNT(s.dealership_id) AS dealership_sales_count
FROM sales s
JOIN dealerships d on d.dealership_id = s.dealership_id 
GROUP BY d.business_name , s.dealership_id 
ORDER BY dealership_sales_count desc;


--How many emloyees are there for each role?
SELECT e.employee_type_id, count(e.employee_type_id) as employee_type_count
FROM employees e
group by e.employee_type_id 
order by e.employee_type_id asc;



--How many finance managers work at each dealership?
-- finance manager id# 2 from employee types table
select * from employeetypes e 

SELECT d.business_name, SUM(CASE WHEN e.employee_type_id  = '2' THEN 1 ELSE 0 END) AS finance_manager_count
FROM dealershipemployees de
join employees e ON e.employee_id = de.employee_id 
join dealerships d on d.dealership_id = de.dealership_id 
group by  d.business_name ;


--Get the names of the top 3 employees who work shifts at the most dealerships?


--What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
select c.state , count(s.sale_id) as customers_in_state 
from customers c 
join sales s on c.customer_id  = s.customer_id 
where s.sale_returned = false
group by c.state
order by customers_in_state desc
limit 5;


--What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
select c.zipcode  , count(s.sale_id) as customers_in_zipcode 
from customers c 
join sales s on c.customer_id  = s.customer_id 
where s.sale_returned = false
group by c.zipcode 
order by customers_in_zipcode desc
limit 5;


--What are the top 5 dealerships with the most customers?
select d.business_name, count (s.customer_id) as dealership_customer_count
from dealerships d
join sales s on s.dealership_id = d.dealership_id 
group by d.business_name 
order by dealership_customer_count desc
limit 5;


--Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT CONCAT(first_name, ' ', last_name) AS full_name, COUNT(sale_id) as total_leases
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
WHERE s.sales_type_id = '2'
GROUP BY s.employee_id, CONCAT(e.first_name, ' ', e.last_name)
order by total_leases desc;



--Who are the top 5 employees for generating sales income?
SELECT CONCAT(first_name, ' ', last_name) AS full_name, SUM(DISTINCT price) AS sales_income
FROM employees
INNER JOIN sales 
USING(employee_id) 
LEFT JOIN dealerships
USING(dealership_id)
GROUP BY full_name
ORDER BY sales_income DESC          
LIMIT 5;

--Who are the top 5 dealership for generating sales income?

SELECT business_name, SUM(DISTINCT price) AS sales_income
FROM employees
INNER JOIN sales 
USING(employee_id) 
LEFT JOIN dealerships
USING(dealership_id)
GROUP BY business_name
ORDER BY sales_income DESC          
LIMIT 5

--Which vehicle model generated the most sales income?

SELECT model, SUM(price) AS sales_income
FROM vehicletypes
LEFT JOIN vehicles          
USING(vehicle_type_id)
INNER JOIN sales
USING(vehicle_id)
GROUP BY model
ORDER BY sales_income DESC
LIMIT 1;

--Which employees generate the most income per dealership?

SELECT DISTINCT ON (business_name) business_name, CONCAT(first_name, ' ', last_name) AS full_name, SUM(price) AS income
FROM sales
INNER JOIN employees 
USING(employee_id)
INNER JOIN dealerships
USING(dealership_id)
GROUP BY business_name, full_name
ORDER BY business_name, income DESC;


--In our Vehicle inventory, show the count of each Model that is in stock.

SELECT model, COUNT(is_sold) AS stock
FROM vehicletypes
INNER JOIN vehicles
USING(vehicle_type_id)
WHERE is_sold = false
GROUP BY model
ORDER BY stock DESC


--In our Vehicle inventory, show the count of each Make that is in stock.
SELECT make, COUNT(is_sold) AS stock
FROM vehicletypes
INNER JOIN vehicles
USING(vehicle_type_id)
WHERE is_sold = false
GROUP BY make
ORDER BY stock DESC


--In our Vehicle inventory, show the count of each BodyType that is in stock.

SELECT body_type , COUNT(is_sold) AS stock
FROM vehicletypes
INNER JOIN vehicles
USING(vehicle_type_id)
WHERE is_sold = false
GROUP BY body_type 
ORDER BY stock DESC


--Which US state's customers have the highest average purchase price for a vehicle?

SELECT DISTINCT state, AVG(price) AS avg_price
FROM customers
INNER JOIN sales 
USING(customer_id)
GROUP BY state
ORDER BY avg_price DESC;

--Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?

SELECT DISTINCT state, AVG(price) AS avg_price
FROM customers
INNER JOIN sales 
USING(customer_id)
GROUP BY state
ORDER BY avg_price desc
limit 5;

--Kristopher Blumfield an employee of Carnival has asked to be transferred to a different dealership location. 
--She is currently at dealership 9. 
--She would like to work at dealership 20. Update her record to reflect her transfer.
SELECT de.employee_id, de.dealership_id, e.first_name, e.last_name 
FROM dealershipemployees de
JOIN employees e ON e.employee_id = de.employee_id
WHERE de.dealership_id = 20;

UPDATE  public.dealershipemployees  
SET dealership_id = 20
WHERE employee_id = 9;

--A Sales associate needs to update a sales record because her customer want to pay with a Mastercard instead of JCB. 
--Update Customer, Ernestus Abeau Sales record which has an invoice number of 9086714242.

SELECT s.invoice_number, s.payment_method, s.customer_id, c.first_name, c.last_name 
FROM sales s
JOIN customers c ON c.customer_id = s.customer_id 
WHERE s.invoice_number  = '9086714242';

UPDATE  public.sales  
SET payment_method = 'mastercard'
WHERE invoice_number  = '9086714242';


--A sales employee at carnival creates a new sales record for a sale they are trying to close. 
--The customer, last minute decided not to purchase the vehicle. 
--Help delete the Sales record with an invoice number of '2436217483'.
DELETE FROM sales 
WHERE invoice_number = '2436217483';


--An employee was recently fired so we must delete them from our database. 
--Delete the employee with employee_id of 35. 
--What problems might you run into when deleting? 
--How would you recommend fixing it?
ALTER TABLE dealershipemployees 
DROP CONSTRAINT dealershipemployees_employee_id_fkey,
ADD CONSTRAINT dealershipemployees_employee_id_fkey
   FOREIGN KEY (employee_id)
   REFERENCES  employees (employee_id)
   ON DELETE CASCADE;
  
ALTER TABLE sales  
DROP CONSTRAINT sales_employee_id_fkey,
ADD CONSTRAINT sales_employee_id_fkey
   FOREIGN KEY (employee_id)
   REFERENCES  employees (employee_id)
   ON DELETE CASCADE;

DELETE FROM employees 
WHERE employee_id  = '35';


--Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
--They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
--When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
--Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

create procedure sell_vehicle(in vehicle_id_param int)
LANGUAGE plpgsql
as $$
	begin	
		update vehicles v
		set v.is_sold = true
		where v.vehicle_id - vehicl_id_param;
end
$$;

call sell_vehicle(1);

create procedure return_vehicle(in vehicle_id_param int)
LANGUAGE plpgsql
as $$
	begin	
		update vehicles v
		set v.is_sold = false
		where v.vehicle_id = vehicl_id_param;
end
$$;

call return_vehicle(1)

--book 3 chapter 5: triggers
CREATE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET pickup_date = NEW.purchase_date + integer '7'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$


CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();
  
 --Create a trigger for when a new Sales record is added, 
 --set the purchase date to 3 days from the current date.
 CREATE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET purchase_date = current_date  + integer '3'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN New;
END;
$$
 
CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();

 
 -- 2. Create a trigger for updates to the Sales table. 
      --If the pickup date is on or before the purchase date, set the pickup date to 7 days after the purchase date. 
      --If the pickup date is after the purchase date but less than 7 days out from the purchase date, add 4 additional days to the pickup date.

	
CREATE OR REPLACE FUNCTION update_sales_dates()
	RETURNS TRIGGER AS $$
	BEGIN
	    IF NEW.pickup_date <= NEW.purchase_date THEN
        	NEW.pickup_date := NEW.purchase_date + INTERVAL '7 days';
        	UPDATE sales SET pickup_date = NEW.pickup_date WHERE sales.sale_id = NEW.sale_id;
    	END IF;
	    
	    IF NEW.pickup_date > NEW.purchase_date AND NEW.pickup_date < NEW.purchase_date + INTERVAL '7 days' THEN
	        NEW.pickup_date := NEW.pickup_date + INTERVAL '4 days';
	        UPDATE sales SET pickup_date = NEW.pickup_date WHERE sales.sale_id = NEW.sale_id;
	    END IF;
	    
	    RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER update_sales_dates_trigger
	AFTER UPDATE ON sales
	FOR EACH ROW
	EXECUTE FUNCTION update_sales_dates();
	

-- pickup date is on same date as purchase date
UPDATE public.sales
	SET pickup_date='2023-06-04'
	WHERE sale_id=5004;

-- pick up date is after purchase date
UPDATE public.sales
	SET pickup_date='2023-06-10'
	WHERE sale_id=5004;


select * from sales where sale_id=5004;
--If the pickup date is after the purchase date but less than 7 days out from the purchase date, add 4 additional days to the pickup date.



--Book 3 chapter 6

--Because Carnival is a single company, we want to ensure that there is consistency in the data provided to the user. 
--Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
--Therefore, any time a new dealership is added or an existing dealership is updated, we want to 
--ensure that the website URL has the following format: 
--http://www.carnivalcars.com/{name of the dealership with underscores separating words}.



--If a phone number is not provided for a new dealership, set the phone number to 
--the default customer care number 777-111-0305.



--For accounting purposes, the name of the state needs to be part of the dealership's tax id. 
--For example, if the tax id provided is bv-832-2h-se8w for a dealership in Virginia, 
--then it needs to be put into the database as bv-832-2h-se8w--virginia.



--Book 3 Chapter 7
--Add a new role for employees called Automotive Mechanic



--Add five new mechanics, their data is up to you



--Each new mechanic will be working at all three of these dealerships: Meeler Autos of San Diego, 
--Meadley Autos of California and Major Autos of Florida



--Create a new dealership in Washington, D.C. called Felphun Automotive



--Hire 3 new employees for the new dealership: Sales Manager, General Manager and Customer Service.



--All employees that currently work at Nelsen Autos of Illinois will now start working at Cain Autos of Missouri instead.


--Book 3 Chapter 8
--Adding 5 brand new 2021 Honda CR-Vs to the inventory. 
--They have I4 engines and are classified as a Crossover SUV or CUV. 
--All of them have beige interiors but the exterior colors are Lilac, Dark Red, Lime, Navy and Sand. 
--The floor price is $21,755 and the MSR price is $18,999.



--For the CX-5s and CX-9s in the inventory that have not been sold, change the year of the car to 2021 
--since we will be updating our stock of Mazdas. For all other unsold Mazdas, update the year to 2020. 
--The newer Mazdas all have red and black interiors.



--The vehicle with VIN KNDPB3A20D7558809 is about to be returned. 
--Carnival has a pretty cool program where it offers the returned vehicle to the most recently 
--hired employee at 70% of the cost it previously sold for. 
--The most recent employee accepts this offer and will purchase the vehicle once it is returned. 
--The employee and dealership who sold the car originally will be on the new sales transaction.



--Book 3 Team Project

--Set up a trigger on the Sales table. When a new row is added, 
--add a new record to the Accounts Receivable table with the deposit as credit_amount, 
--the timestamp as date_received and the appropriate sale_id.
create TABLE Accounts_Receivable (
  id SERIAL PRIMARY KEY,
  credit_amount NUMERIC(10,2),
  date_received TIMESTAMP NOT NULL DEFAULT NOW(),
  sale_id INTEGER REFERENCES sales(sale_id)
);


CREATE OR REPLACE FUNCTION insert_into_accounts_receivable() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO Accounts_Receivable (credit_amount, date_received, sale_id)
  VALUES (NEW.deposit, NOW(), NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_into_accounts_receivable_trigger
AFTER INSERT ON Sales
FOR EACH ROW
EXECUTE FUNCTION insert_into_accounts_receivable();


/*
2. Set up a trigger on the Sales table for when the sale_returned flag is updated. 
Add a new row to the Accounts Receivable table with the deposit as debit_amount, the timestamp as date_received, etc.
*/



CREATE OR REPLACE FUNCTION update_accounts_receivable()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the sale_returned flag has been updated
    IF OLD.sale_returned IS DISTINCT FROM NEW.sale_returned THEN
        -- If the flag has been set to true, insert a new row into the Accounts Receivable table
        IF NEW.sale_returned = 'true' THEN
            INSERT INTO Accounts_Receivable (debit_amount, date_received, sale_id)
            VALUES (NEW.deposit, NOW(), new.sale_id);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE or replace TRIGGER update_accounts_receivable
	AFTER UPDATE ON sales
	FOR EACH ROW
	EXECUTE FUNCTION update_accounts_receivable();


UPDATE public.sales
	SET sale_returned=true
	WHERE sale_id=6;


select * from sales;
select * from accounts_receivable;


--Create a stored procedure with a transaction to handle hiring a new employee. 
--Add a new record for the employee in the Employees table and add a record to the Dealershipemployees table 
--for the two dealerships the new employee will start at.
3.
CREATE OR REPLACE PROCEDURE hire_employee_proc(
    IN p_first_name VARCHAR,
    IN p_last_name VARCHAR,
    IN p_email_address VARCHAR,
    IN p_phone VARCHAR,
    IN p_employee_type_id INTEGER,
    IN p_dealership1_id INTEGER,
    IN p_dealership2_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_employee_id INTEGER;
BEGIN
    -- Add new record to Employees table
    INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
    VALUES(p_first_name, p_last_name, p_email_address, p_phone, p_employee_type_id)
    RETURNING employee_id INTO p_employee_id;

   -- Add new record to Dealershipemployees table for dealership1
   	INSERT INTO dealershipemployees(dealership_id, employee_id)
	VALUES(p_dealership1_id, p_employee_id);

    -- Add new record to Dealershipemployees table for dealership2
	INSERT INTO dealershipemployees(dealership_id, employee_id)
	VALUES(p_dealership2_id, p_employee_id);
    -- Commit the transaction
    COMMIT;
END;
$$;

call hire_employee_proc('brooke', 'weathers', 'hello@me.com', '916-920-8924', 1, 2, 3);





--Create a stored procedure with a transaction to handle an employee leaving. 
--The employee record is removed and all records associating the employee with dealerships must also be removed.

CREATE or replace PROCEDURE remove_employee(id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM dealershipemployees WHERE employee_id = id;
  DELETE FROM employees WHERE employee_id = id;
  COMMIT;
END;
$$;


call remove_employee(1006);

select * from employees where employee_id=1006;
select * from dealershipemployees where employee_id=1006;


