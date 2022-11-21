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


---which item was purchased first by the customer after they became a member?

select * from
(select *,rank() over(partition by userid order by  created_date )Rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b 
on a.userid=b.userid and a.created_date>b.gold_signup_date )c)d where Rnk=1

---which item was purchased first by the customer before they became a member?

select * from
(select *,rank() over(partition by userid order by  created_date desc )Rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b 
on a.userid=b.userid and a.created_date<b.gold_signup_date )c)d where Rnk=1


---what is the total order and amount spent for each member before they became a member?

select userid, count(created_date)total_order,sum(price)amount  from
(select c.*,d.price from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b 
on a.userid=b.userid and a.created_date<b.gold_signup_date)c 
 inner join product d on c.product_id=d.product_id)e
 group by userid 


 ----if buying each product generate points for eg 5rs=2 zomato point and each product has different purchasing point for eg for p1 
-- 5rs=1 zomato point, for p2  10rs= 5 zomato point and p3 5rs =1 zomato point
----, calculate point collected by each customer and for which product most point has given till now?


 select *,Point*2.5 Total_point from
 (select f.userid,sum(total_point) Point from
 (select e.*,total/points total_point from 
 (select d.*,case when product_id=1  then 5 when product_id=2 then 2 when product_id = 3  then 5 else 0 end as points from
 (select c.userid,c.product_id,sum(price)total from
(select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id= b.product_id)c
 group by userid,product_id)d)e)f
 group by userid )g


 select * from
  (select *, rank() over( order by Point desc)Rnk from
 (select f.product_id,sum(total_point) Point from
 (select e.*,total/points total_point from 
 (select d.*,case when product_id=1  then 5 when product_id=2 then 2 when product_id = 3  then 5 else 0 end as points from
 (select c.userid,c.product_id,sum(price)total from
(select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id= b.product_id)c
 group by userid,product_id)d)e)f
 group by product_id )g)h
 where Rnk=1


 ----in the first one year after a customer joins the gold program (including their join date) irrespective 
 ---of what the customer has purchased they earn 5 zomato point for every 10 rs spent who earned more 1 or 3 and what was 
 --their point earning in their first yr?

 1zp=2 rs

 select c.*,d.price,d.price*0.5 zp_point from 
( select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b 
on a.userid=b.userid and a.created_date>b.gold_signup_date and created_date<=DATEADD(YEAR,1,gold_signup_date)
)c inner join product d on c.product_id=d.product_id


----rank all the transaction of customer?

select *,rank() over(partition by userid order by created_date)rnk from sales

----rank all the transaction for each member whenever they are a zomato gold member for every non 
--gold member transaction mark as na?


select e.* , case when rnk = 0 then 'na' else rnk end as rnkk from
(select c.*,cast((case when gold_signup_date is NULL then 0 else  
rank() over(partition by userid order by created_date desc) end)as varchar) as rnk  from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a left join goldusers_signup b 
on a.userid=b.userid and a.created_date>b.gold_signup_date)c)e
































