
--Count transactions by status
select count(*) from transaction group by status

--Calculate total captured GMV by merchant
select sum(amount) from transaction group by merchant_name 

--Show top 10 merchants by captured GMV
select * from transaction group by merchant_name 
order by amount desc 
limit 10

Show daily GMV and successful transaction count
select * from transaction group by merchant_name 
status = "captured"
order by amount desc 
limit 10


Find merchants with chargeback ratio above 1%
select * from transaction group by high value risk 



Find regions with average risk score above 50 and more than 20 transactions
select * from transaction 

Find users with 3 or more failed or chargeback transactions on the same day
select * from transaction high_value_risk
Show chargeback count, unique affected users, and chargeback amount by merchant
select * from transaction high_value_risk