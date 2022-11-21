use practice
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

---what is the total amount each customer spent on zomato?

select a.userid,sum(b.price)price from sales a inner join product b on a.product_id=b.product_id
group by a.userid

select * from sales a inner join product b on a.product_id=b.product_id

---How many days has each customer visited zomato?

select a.userid,count(distinct a.created_date)date_count from sales a inner join product b on a.product_id= b.product_id
group by a.userid

select a.userid, a.created_date from sales a inner join product b on a.product_id= b.product_id


----what was the first product purchase by each customer?

select * from
(select *, rank() over(partition by userid order by created_date )Rnk from sales )a where Rnk in (1)


----what is the most purchased item on the menu and how many times was it purchased by all customers?

select a.product_id,count(a.product_id) from sales a inner join product b on a.product_id=b.product_id
group by a.product_id

count(distinct b.product_name)
select a.userid,b.product_name from sales a inner join product b on a.product_id=b.product_id 
group by a.product_id

select top 1 product_id from sales group by product_id order by count(product_id) desc


select userid,count(userid)times_purchased from sales where product_id=
(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid order by count(userid) desc


----which item was most popular for each customer?
select * from (
select *, rank() over( partition by userid order by product_pop desc)Rnk from
(select userid,product_id,count(product_id)product_pop from sales group by userid,product_id )a)b
where Rnk =1
















