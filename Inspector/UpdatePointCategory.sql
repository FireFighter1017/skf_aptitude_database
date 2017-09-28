-- *** UpdatePointCategory ***********************
-- 
-- Author: Pascal Bellerose
-- Goal:   Update point filter key in cas_MeasStatus
-- 
update cas_measstatus 
set pointcategory = cat.valuestr
from skfuser1.treeelem te
	left outer JOIN skfuser1.POINTCAT AS pcat ON pcat.ELEMENTID = te.REFERENCEID 
	left outer JOIN skfuser1.CATEGORY AS cat ON cat.CATEGORYID = pcat.CATEGORYID  
where te.treeelemid = cas_measstatus.routepointid and machineName like '%PIV%'
 

select * 
from pointcat 
join cas_tree t on t.Childid = elementid 
join treeelem te on te.treeelemid=elementid
where CATEGORYID=32 and Location like '%\OEXTRES\%' order by location

 --update pointcat set parentid = 0 where categoryid=32

--delete from pointcat where categoryid=31 and elementid in (select childid from pointcat join cas_tree t on t.Childid = elementid where CATEGORYID=31 and location like '%\_EXTRES%')


select * from pointcat where elementid in (
select childid from cas_tree where Location like '\Hiérarchie%' and Location like '%\OEXTRES\%'
)

select * from pointcat join cas_tree t on t.Childid = elementid where CATEGORYID=31 order by location

select * From cas_tree where (location like '\hiérarchie\%\_EXT___\%' or location like '\hiérarchie\%\_EXTI___\%') and childid not in (select elementid from pointcat where categoryid=32)

select * From cas_tree where location like '\hiérarchie\%\_RESE___%'

Select cat.CATEGORYID, cat.VALUESTR, t.treeelemid, m.name, t.name from CATEGORY cat join pointcat pc on pc.CATEGORYID=cat.CATEGORYID join treeelem t on t.TREEELEMID=pc.ELEMENTID join TREEELEM m on m.TREEELEMID=t.PARENTID
where m.containertype= 3 and m.description like 'BOYAU INC.%'
group by cat.CATEGORYID, cat. VALUESTR

USE [skfuser]
GO

INSERT INTO [skfuser1].[POINTCAT]
select 0, 32, childid from cas_tree join treeelem te on te.treeelemid=childid where Location like '\Hiérarchie%\RESE%' and containertype in (2,3,4)
GO

Delete from pointcat where categoryid=32


INSERT INTO [skfuser1].[POINTCAT]
select 0, 31, childid From cas_tree where (location like '\hiérarchie\%\_EXT___\%' or location like '\hiérarchie\%\_EXTI___\%') and childid not in (select elementid from pointcat where categoryid=32)

Select * From category