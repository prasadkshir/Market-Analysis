-- Project name [CDACL-006 Market Analysis] ---

-- 1]What are the top 10 aisles with the highest number of products?

select a.aisle,count(product_name) from aisles as a left join products as p
on a. aisle_id=p.aisle_id group by a.aisle
order by count(product_name) desc
limit 10;


-- 2]How many unique departments are there in the dataset?

select count(distinct(department)) from departments;


-- 3]What is the distribution of products across departments?

select  d.department,count(product_id) from departments as d left join 
products as p on d.department_id=p.department_id
group by d.department order by count(product_id);


-- 4]What are the top 10 products with the highest reorder rates?

select p.product_name,count(reordered) from products as p join
order_products_train as opt on p.product_id=opt.product_id
where reordered in (1)
group by p.product_name
order by count(reordered) desc
limit 10;


-- 5]How many unique users have placed orders in the dataset?

select count(distinct(user_id)) from orders;


-- 6]What is the average number of days between orders for each user?

select distinct(user_id),avg(days_since_prior_order)  from orders group by user_id;


-- 7]What are the peak hours of order placement during the day?

select order_hour_of_day,count(order_id) from orders group by order_hour_of_day  order by count(order_id) desc;
-- from data we can say that (10,11,14,15,13,12,16,9,17) hours are peak hours


-- 8]How does order volume vary by day of the week?

select order_dow,count(order_id)  from orders group by order_dow;
-- data can show how the order volume vary by day of week
-- sunday have most order volume
-- saturday have least order volume



-- 9]What are the top 10 most ordered products?

select p.product_name,count(opt.order_id) from products as p
join order_products_train as opt on p.product_id=opt.product_id
group by product_name
order by count(opt.order_id) desc
limit 10;
-- banana is most ordered product
-- Organic Raspberries is least order product amoung top 10 


-- 10]How many users have placed orders in each department?

select d.department,count(distinct(o.user_id)) from departments as d
join products as p on d.department_id=p.department_id
join order_products_train as opt on p.product_id=opt.product_id
join orders as o on opt.order_id=o.order_id
group by d.department order by count(distinct(o.user_id));
-- highest orders has been placed in produce department
-- least orders has been placed in bulk department


-- 11]What is the average number of products per order?

-- average number of products per order= Total number of Products/Total Paid orders

select count(distinct(p.product_id)),count(opt.order_id),count(distinct(p.product_id))/count(distinct(opt.order_id)) as avg_no_of_products from products as p
join order_products_train as opt on p.product_id=opt.product_id;


-- 12]What are the most reordered products in each department?

select count(opt.reordered),d.department,p.product_name from departments as d
join products as p on d.department_id=p.department_id
join order_products_train as opt on p.product_id=opt.product_id
where opt.reordered in (1)
group by d.department,p.product_name
order by department desc;

-- in this way we get to know products,departments and how many
-- times they have been reordered


-- 13]How many products have been reordered more than once?

select count(p.product_id),opt.reordered from products as p 
join order_products_train as opt on p.product_id=opt.product_id
group by opt.reordered
having opt.reordered in (1) and count(p.product_id) >1;

select count(reordered) from order_products_train where reordered in (1);
-- Total Products that are reordered = 627608
-- Products reordered more than once = 623710


-- 14]What is the average number of products added to the cart per order?

select count(distinct(add_to_cart_order))/count(distinct(order_id)) from order_products_train;


-- 15]How does the number of orders vary by hour of the day?

select count(order_id),order_hour_of_day from orders
group by order_hour_of_day;
-- we are checking number of orders in different hours of the day


-- 16]What is the distribution of order sizes (number of products per order)?

select count(distinct(product_id)) /count(distinct(order_id) ) as number_of_products_per_order from order_products_train;

-- 17]What is the average reorder rate for products in each aisle?

select a.aisle,avg(p.product_id) from aisles as a join 
products as p on a.aisle_id=p.aisle_id join 
order_products_train as opt on p.product_id=opt.product_id
where opt.reordered in (1)
group by a.aisle;


-- 18]How does the average order size vary by day of the week?

-- here we have to find average number of  orders in day of week

select order_dow,count(order_id),count(order_id)/24 as average_orders_in_day from orders 
group by order_dow;

-- count(order_id) gives total no of orders
-- average number of orders in day of week = count(order_id)/24


-- 19]What are the top 10 users with the highest number of orders?

select count(order_id),user_id  from orders
group by user_id
order by count(order_id) desc
limit 10;

-- these top 10 user have placed 100 orders each


-- 20]How many products belong to each aisle and department?

select a.aisle, count(p.product_id),d.department from aisles as a 
join products as p on a.aisle_id=p.aisle_id
join departments as d on p.department_id=d.department_id
group by a.aisle,d.department
order by count(p.product_id);


-- analyze customer purchasing behavior -----------------------------

select count(order_id),order_hour_of_day from orders group by order_hour_of_day
order by count(order_id);
-- most of the users giving order at 10am 


select order_dow,count(order_id) from orders group by order_dow
order by count(order_id);
-- at 0 order dow count(order_id) is most so more customers giving most orders on sunday


select days_since_prior_order,count(user_id) from orders 
group by days_since_prior_order order by count(user_id) desc;
-- most of the customers have not ordered since 30 days


select opt.reordered,count(user_id) from orders as o
join order_products_train as opt on o.order_id=opt.order_id
group by opt.reordered;
-- most of the customers have reordered the products


select opt.reordered,count(user_id),a.aisle  from orders as o
join order_products_train as opt on o.order_id=opt.order_id
join products as p  on opt.product_id=p.product_id
join aisles as a on p.aisle_id=a.aisle_id
where opt.reordered in (1)
group by opt.reordered,a.aisle
order by count(user_id) desc;
-- customers purchasing i.e reordered most of products from fresh fruits aisle


select count(opt.reordered),p.product_name from orders as o
join order_products_train as opt on o.order_id=opt.order_id
join products as p  on opt.product_id=p.product_id
group by p.product_name order by count(opt.reordered) desc;

--  Banana is most purchase product by customers


-- product performance analysis ------------------------


select p.product_name,count(order_id) from products as p join order_products_train as opt
on p.product_id=opt.product_id group by p.product_name order by count(order_id) desc;
-- banana is most ordered product 
-- 2nd Foods Nature Select Blended Fruits with Oatmeal is least order product along with some other product


select p.product_name,count(opt.reordered) from products as p join order_products_train as opt
on p.product_id=opt.product_id  where opt.reordered in (1)
group by p.product_name
order by count(opt.reordered) desc;
-- banana is most reordered product
-- Frozen Desserts, Fit, Salted Caramel is the least reordered product along with some other products


select p.product_name,count(opt.add_to_cart_order) from products as p join
order_products_train as opt on p.product_id=opt.product_id group by p.product_name
order by count(add_to_cart_order) desc ;
-- banana is added highest to the cart
-- 2nd Foods Nature Select Blended Fruits with Oatmeal is least added to cart along with some other products


select p.product_name ,o.days_since_prior_order from products as p join
order_products_train as opt on p.product_id=opt.product_id join orders as o
on opt.order_id=o.order_id  ;

-- this shows that different products and time since they ordered last 



















