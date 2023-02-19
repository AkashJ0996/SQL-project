create database proj1;
use proj1;

#lets create tables as showm in our E-R diagram 
#here i am creating tables that will showcase all the customer's regions , transaction history , and their node details.

#table 1 called regions
create table regions (
region_id int primary key ,
region_name varchar(9) );

#lets insert some values in it
insert into regions values (400011,"Mumbai"),(400014,"Dadar"),(400027,"Byculla"),(400053,"Andheri"),
(400091,"Borivli"),(401101,"Bhayander"),(401305,"Virar");

#to see all the details from the table 
select * from regions;

#table 2 called customer_nodes which consist of details such as end date,start date,node id etc.
create table customer_nodes (
customer_id int primary key ,
region_id int ,
node_id int ,
start_date date,
end_date date ,
foreign key f_k (region_id) references regions(region_id));


#lets insert some values in table 2 
insert into customer_nodes values (1001,401305,7,"2023-01-14","2023-04-14"),(1002,400011,1,"2023-01-20","2023-04-20"),
(1003,400053,4,"2023-01-04","2023-07-04"),(1004,401305,7,"2023-01-07","2024-01-07"),(1005,400053,4,"2022-12-28","2023-03-28"),
(1006,401305,7,"2023-01-28","2023-04-28");
insert into customer_nodes values (1007,400014,2,"2022-01-14","2022-02-14"),(1008,400091,5,"2022-01-07","2023-01-07"),
(1009,401101,6,"2022-06-10","2022-09-10");

#to see all the details from table 2 
desc customer_nodes ;#to see all the column detail eg: which column is primary key ,which one is foreign key
select * from customer_nodes;

#table 3 will have all the details regarding amount , transaction type etc. 
create table customer_transaction (
customer_id int,
txn_date date,
txn_type varchar(10),
txn_amount int ,
foreign key c_fk (customer_id) references customer_nodes(customer_id));

#lets insert some values in table 2
insert into customer_transaction values (1001,"2023-01-14","UPI",800),(1002,"2023-01-20","UPI",800),
(1003,"2023-01-04","NetBanking",1600),(1004,"2023-01-07","CreditCard",2200),
(1005,"2022-12-28","CreditCard",800),(1006,"2023-01-28","UPI",800);

#to see all the details and structure of table 3
desc customer_transaction;
select * from customer_transaction;
#---------------------------------------------------------------------------------------------------------
#lets write some queries to retrieve information fro these tables
#basic queries
select * from customer_nodes where region_id = 401305;
select node_id from customer_nodes where region_id =400011;

select region_name from regions where region_id=400053;

#logical operators
select txn_date,txn_type from customer_transaction where 
customer_id=1001 or customer_id = 1005;
select txn_date,txn_type from customer_transaction where 
customer_id in (1003,1004,1006);
select txn_date,txn_type from customer_transaction where 
customer_id between 1002 and 1005;

select customer_id,txn_type,txn_amount from customer_transaction where 
txn_amount >200 and txn_amount <900;
select customer_id,txn_type,txn_amount from customer_transaction where 
txn_amount between 1600 and 2500;

#queries that uses specific pattern 
select region_name from regions where region_name like "B%";#all names start with B
select region_name from regions where region_name like "%i";#all names end with i
select region_name from regions where region_name like "_y%";#all names which consist y as a second character

#using order by clause
select * from customer_transaction order by txn_amount;#by default in ascending order 
select * from customer_transaction order by txn_amount desc ;#descending order
#using limit clause
select * from customer_transaction order by txn_amount limit 5,1; #will give us only last l row 
select * from customer_transaction order by txn_amount limit 2,2;#will give us 3 and 4 row

#lets use some agg. functions
select min(txn_amount) from customer_transaction ;
select max(txn_amount) from customer_transaction ;
select avg(txn_amount) from customer_transaction ;
# similarly we can use  greatest(),least(),sum() agg. functions

#------------------------------------------------------------------------------------------------
# lets use some alter command to update table structure 

alter table customer_nodes add column customer_name varchar(20) after customer_id ;#it will add column name after customer id

alter table customer_transaction modify column txn_type varchar(12) ;#will modify datatype varchar(10) to varchar(12)

#to add values in newly created column we can use update command 
update customer_nodes set customer_name ="mr.Abc" where customer_id = 1001;
update customer_nodes set customer_name ="mr.Pqr" where customer_id = 1002;
update customer_nodes set customer_name ="mr.Efg" where customer_id = 1003;
update customer_nodes set customer_name ="mr.Hij" where customer_id = 1004;
update customer_nodes set customer_name ="mr.Abc D." where customer_id = 1005;
update customer_nodes set customer_name ="mr.Xyz" where customer_id = 1006;

#to see updated result we can use following queries 
select * from customer_nodes ;
#or
select customer_name from customer_nodes ;

#if we dont want this column we can delete using alter command
alter table customer_nodes drop column customer_name ;
select * from customer_nodes ;#see its delete now 

#-----------------------------------------------------------------------------------------------
#group by- having clause 

#sql command group by groups the row by the given column 
select node_id , count(node_id) from customer_nodes group by node_id;
#use of having in group by 
select node_id , count(node_id) from customer_nodes group by node_id having node_id = 7;
#similarly ...we can use agg.(aggrigate) functions with group by having clause
select txn_amount , count(txn_amount) from customer_transaction group by txn_amount having min(txn_amount) = 800;
select txn_amount , count(txn_amount) from customer_transaction group by txn_amount having avg(txn_amount)>1000;

#------------------------------------------------------------------------------------------------
#sub-queries also known as neasted queries

select txn_amount,txn_type from customer_transaction where 
txn_amount > (select min(txn_amount) from customer_transaction);

select region_id,count(region_id) from customer_nodes where 
region_id in (select region_id from customer_nodes where  region_id = 401305 );

update customer_transaction set txn_amount = 150 + txn_amount where 
txn_amount in (select txn_amount from customer_transaction where txn_amount = 800) ;
#to see updation
select * from customer_transaction ;

#---------------------------------------------------------------------------------------------------
#index
 /*the create index statment is used to create indexes in table these are used to retrieve data from the database 
 more quickly than otherwise, the users can not see the indexes they are just use to speed up searches or queries*/

create index tx_index on customer_nodes (end_date);
select region_id from customer_nodes where end_date in ("2023-03-28","2023-04-28");

create index st_index on customer_nodes (start_date);
select region_id from customer_nodes where start_date in ("2023-01-28","2023-01-07","2023-01-04");

create index t_index on customer_transaction (txn_date,txn_amount);
select customer_id,txn_amount from customer_transaction where txn_date in ("2023-01-28","2023-01-07","2023-01-04") and  txn_type = "UPI";

#we can delete all these indexes from tables
alter table customer_nodes drop index tx_index ;
alter table customer_nodes drop index st_index ;
alter table customer_transaction drop index t_index ;

#------------------------------------------------------------------------------------------------------------
# views : views are a virtual tables it creates table which do not occupy any space in the memory 
#will show only specific column from the table to other user
# example:
select * from customer_transaction ;#we can see whole table by executing this query
#lets create view on this table to show only customer_id and txn_amount to other user 
create view only_show as select customer_id , txn_amount from customer_transaction ;
select * from only_show ;#to see virtual table created using view 

# we can also delete view from table
drop view only_show ;

#-----------------------------------------------------------------------------------------------------------
#joins...
#lets use join on regions table and customer_nodes table as they both has same column called region_id 
# to apply join we must know that each table must contain same name column 
#lets apply inner join on both the table it will only shows the match data that is available inside both the table 
select region_name , node_id , regions.region_id from regions inner join customer_nodes
 on regions.region_id = customer_nodes.region_id ;
 /*cross join : it will connect each row of one table  to  all the rows of other table also know as crossproduct of table
 #if we apply equal condition with crossproduct then it is know as natural join  */
 
 #cross join....
 select region_name , node_id , regions.region_id from regions, customer_nodes;
 #similarly we can use cross join
 select region_name , node_id , regions.region_id from regions cross join customer_nodes;
 
#natural join = crossproduct + equal(=) condition
select region_name , node_id , regions.region_id from regions,customer_nodes where
regions.region_id = customer_nodes.region_id;
#similarly we can use natural join 
select region_name , node_id , regions.region_id from regions natural join customer_nodes ;

#left join : will give all the information that is match in left table + all left tables data
#lets apply left join on table customer_nodes and customer_transaction as they both has customer_id column
select  customer_nodes.customer_id , node_id , customer_transaction.customer_id from customer_nodes left join customer_transaction
on customer_nodes.customer_id = customer_transaction.customer_id ;
#similarly for right join : it will give all the match content + all right table data
select  customer_nodes.customer_id , node_id , customer_transaction.customer_id from customer_nodes right join customer_transaction
on customer_nodes.customer_id = customer_transaction.customer_id ;

#to delete foreign key 
alter table customer_nodes drop foreign key f_k ;
#similarly 
alter table customer_transaction drop foreign key c_fk ;

# to delete all the tables 
drop table regions ;
drop table customer_nodes;
drop table customer_transaction ;
 
# to delete database 
drop database proj1;