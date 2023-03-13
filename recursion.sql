/* Using CTE in order to implement recursion */
/* example pattern */

declare @company table (
	id int,
	ctc varchar(10), 
	id_parent int
)

insert into @company values (1, '1', null)
insert into @company values (2, '2', null)
insert into @company values (3, '3', 1)
insert into @company values (4, '4', 3)


;WITH COMPANY (id, ctc, id_parent) AS (
	select id, ctc, id_parent
	from @company where id_parent is null
	union all
	select comp.id, comp.ctc, comp.id_parent
	from @company comp
	inner join COMPANY c on c.id = comp.id_parent
)
select * from COMPANY

