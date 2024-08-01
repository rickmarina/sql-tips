-- Good use of bitwise operations to determine action inside a trigger 

use tempdb
;
create table dbo.TrigAction (asdf int)
;
GO
create trigger dbo.TrigActionTrig
on dbo.TrigAction
for INSERT, UPDATE, DELETE
as
declare @Action tinyint
;
-- Create bit map in @Action using bitwise OR "|"
set @Action = (-- 1: INSERT, 2: DELETE, 3: UPDATE, 0: No Rows Modified 
  (select case when exists (select * from inserted) then 1 else 0 end)
| (select case when exists (select * from deleted ) then 2 else 0 end))
;
-- 21 <- Binary bit values
-- 00 -> No Rows Modified
-- 01 -> INSERT -- INSERT and UPDATE have the 1 bit set
-- 11 -> UPDATE <
-- 10 -> DELETE -- DELETE and UPDATE have the 2 bit set

raiserror(N'@Action = %d', 10, 1, @Action) with nowait
;
if (@Action = 0) raiserror(N'No Data Modified.', 10, 1) with nowait
;
-- do things for INSERT only
if (@Action = 1) raiserror(N'Only for INSERT.', 10, 1) with nowait
;
-- do things for UPDATE only
if (@Action = 3) raiserror(N'Only for UPDATE.', 10, 1) with nowait
;
-- do things for DELETE only
if (@Action = 2) raiserror(N'Only for DELETE.', 10, 1) with nowait
;
-- do things for INSERT or UPDATE
if (@Action & 1 = 1) raiserror(N'For INSERT or UPDATE.', 10, 1) with nowait
;
-- do things for UPDATE or DELETE
if (@Action & 2 = 2) raiserror(N'For UPDATE or DELETE.', 10, 1) with nowait
;
-- do things for INSERT or DELETE (unlikely)
if (@Action in (1,2)) raiserror(N'For INSERT or DELETE.', 10, 1) with nowait
-- if already "return" on @Action = 0, then use @Action < 3 for INSERT or DELETE
;
GO

set nocount on;

raiserror(N'INSERT 0...', 10, 1) with nowait;
insert dbo.TrigAction (asdf) select top 0 object_id from sys.objects;

raiserror(N'INSERT 3...', 10, 1) with nowait;
insert dbo.TrigAction (asdf) select top 3 object_id from sys.objects;

raiserror(N'UPDATE 0...', 10, 1) with nowait;
update t set asdf = asdf /1 from dbo.TrigAction t where asdf <> asdf;

raiserror(N'UPDATE 3...', 10, 1) with nowait;
update t set asdf = asdf /1 from dbo.TrigAction t;

raiserror(N'DELETE 0...', 10, 1) with nowait;
delete t from dbo.TrigAction t where asdf < 0;

raiserror(N'DELETE 3...', 10, 1) with nowait;
delete t from dbo.TrigAction t;
GO

drop table dbo.TrigAction
;
GO