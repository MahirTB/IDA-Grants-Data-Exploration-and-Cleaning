-- exploring data from the ProjectTable
select top 10 *
from [IDA Loan]..ProjectTable
order by [Credit Number]

-- exploring data from BorrowerTable
select distinct top 10 *
from [IDA Loan]..BorrowerTable
order by [Credit Number]

-- removing unnecessary columns from ProjectTable
alter table [IDA Loan]..BorrowerTable
drop column [End of Period]


-- getting rid of the duplicate values
with duplicate as(
select b.Country, b.[Credit Number], p.[Project ID], p.[Project Name], p.[Disbursed Amount (US$)],
	   ROW_NUMBER() over(partition by
       p.[Project ID]
	   order by p.[Project ID]) as row_num
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b on p.[Credit Number]=b.[Credit Number]
)
select *
from duplicate
where row_num=1
order by [Project ID]

-- deleting the duplicates
select *, ROW_NUMBER() over(partition by [Project ID] order by [Project ID]) as rownum
from [IDA Loan]..ProjectTable
where [Project ID] IN (
    SELECT [Project ID]
    FROM [IDA Loan]..ProjectTable p
    JOIN [IDA Loan]..BorrowerTable b ON p.[Credit Number] = b.[Credit Number]
    GROUP BY p.[Project ID]
    HAVING COUNT(*) = 1
)

-- each project has multiple grants from IDA, hence multiple credit number for the same project
select distinct p.[Project ID], b.[Credit Number], p.[Project Name], p.[Disbursed Amount (US$)]
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b
on p.[Credit Number]=b.[Credit Number]

--highest grant by IDA
select p.[Project ID], p.[Project Name], b.Country, p.[Disbursed Amount (US$)]
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b
on p.[Credit Number]=b.[Credit Number]
where [Disbursed Amount (US$)]=(select max([Disbursed Amount (US$)])
								from [IDA Loan]..ProjectTable)

-- total projects by country
select b.Country, count(distinct p.[Project ID]) as Total_Projects
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b
on p.[Credit Number]=b.[Credit Number]
group by b.Country
order by Total_Projects desc

--
select b.Country, sum(distinct p.[Disbursed Amount (US$)]) as Total_Amount
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b
on p.[Credit Number]=b.[Credit Number]
group by b.Country
order by Total_Amount desc

select distinct([Project ID]), p.[Credit Number], [Disbursed Amount (US$)], b.Country
from [IDA Loan]..ProjectTable p
join [IDA Loan]..BorrowerTable b
on p.[Credit Number]=b.[Credit Number]
where b.Country='vietnam'





--creating a view to use it in visualization
go
CREATE VIEW LoanbyCountry
AS
SELECT DISTINCT b.Country, b.[Credit Number], p.[Project ID], p.[Project Name], p.[Disbursed Amount (US$)]
FROM [IDA Loan]..BorrowerTable b
JOIN [IDA Loan]..ProjectTable p ON p.[Credit Number] = b.[Credit Number];
go

select *
from LoanbyCountry


