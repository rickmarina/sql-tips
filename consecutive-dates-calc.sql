-- Rellenar una tabla con fechas secuenciales y realizar un update sobre estas con los datos de otra tabla


declare @datos table (
	fecha datetime, 
	valor float 
)

declare @final table (
	fecha datetime, 
	valor float 
)


insert into @datos values ('20220801', 10) , ('20220815', 11), ('20220820', 12)
insert into @final select * from @datos


Declare @year int = 2022, @month int = 8;
WITH numbers
as
(
    Select 1 as value
    UNion ALL
    Select value + 1 from numbers
    where value + 1 <= Day(EOMONTH(datefromparts(@year,@month,1)))
)
insert into @final 
SELECT datefromparts(@year,@month,numbers.value) Datum, (select top 1 valor from @datos where fecha < datefromparts(@year,@month,numbers.value) order by fecha desc)
FROM numbers
where not exists (select 1 from @datos where fecha = datefromparts(@year,@month,numbers.value))


select * from @datos

select * from @final
order by 1
