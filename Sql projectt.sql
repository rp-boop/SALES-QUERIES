use retail_projects
select*from [retails projects]

          ///**--DATA EXPLORATION AND CLEANING---**///

---- **Record Count**: Determine the total number of records in the dataset.
select count(*) records_count from [retails projects]

---- **Customer Count**: Find out how many unique customers are in the dataset.
select distinct count(customer_id) unique_records from [retails projects]

---- **Category Count**: Identify all unique product categories in the dataset.
select distinct category from [retails projects]

---- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
select * from [retails projects]
  where 
          sale_date is null or sale_time  is null or customer_id is null
          or gender is null or age is null or category is null or quantiy
		  is null or price_per_unit is null or cogs is null
          

delete from [retails projects]
    where 
	       sale_date is null or sale_time is  null or customer_id is null
		   or gender is null or age is null or category is null or 
		   quantiy is null or price_per_unit is null or cogs is null

		   ---Data analysis and findings--

	---1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**.
	select * from [retails projects]
	where sale_date='2022-11-05'

	--2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**
	select * from [retails projects]
	where category='clothing' and DATEPART(year,sale_date)=2022 and DATEPART(month,sale_date)=11 and quantiy>=4

   ---3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
   select category,SUM(total_sale) from [retails projects] group by category

   ---4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
   select AVG(age) as avg from [retails projects] where category ='beauty'

   ---5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
   select * from [retails projects] where total_sale>1000	

    --6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
	select category,gender ,count(*) as total_trans from [retails projects]
	group by category ,gender

    --by pivot 
     select category ,[male],[female] from (select category,gender,count(*) as gendercount from [retails projects]
     group by category,gender) as source_table
 pivot
(
      sum(gendercount) for gender in ([male],[female]))as pivotTable

    ---7.  **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
	 
	   select distinct(year(sale_date)) from [retails projects]

	   with cte as(select*,ROW_NUMBER()over (partition by year(sale_date),month(sale_date)order by total_sale desc)R from [retails projects])

	   SELECT top(2) year(sale_date)y,MONTH(sale_date)m,AVG(total_sale)s from cte group by YEAR(sale_date),MONTH(sale_date)
	   order by s desc
	   

	--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
	   select top(5) customer_id,SUM(total_sale) as T
	   from [retails projects] group by customer_id order by T desc


    --9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
	select category,count(distinct customer_id) as unique_number from [retails projects] group by category

	--10.  **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
        
	    with cte as (

	        	select *,IIF(datepart(hour,sale_time)<12,'morning',
		         iif(datepart(hour,sale_time)between 12 and 17,'afternoon','evening')) condition from [retails projects])

				 select condition,count(*) number from cte group by condition 

 
 select Age,[clothing],[beauty] from 
 (select age,category,sum(total_sale)sales from [retails projects] group by age,category )as source_table
 pivot
 (
 sum(Total_Sale) for age in ([clothing],[beauty]) ) as pivot_table

 
 ---### FINDINGS ###---

- **Customer Demographics**

 The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.

 with cte as(
              select*,IIF(age<25,'adult',
			          IIF (age<45,'teenager','senior')) [age group] from [retails projects])

					  select category,[age group],SUM(total_sale) from cte
					  where category in ('clothing','beauty') group by category ,[age group]


- **High-Value Transactions**: 

Several transactions had a total sale amount greater than 1000, indicating premium purchases.
select count(*)from [retails projects]
where total_sale>1000 group by total_sale

- **Sales Trends**
Monthly analysis shows variations in sales, helping identify peak seasons.

select sum(total_sale) as total_sale ,datename( month,sale_date) as sales_trend from [retails projects] group by datename( month,sale_date)



 



