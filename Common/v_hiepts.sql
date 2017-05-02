-- HIERARCHY POINTS
-- Hierarchy type 1 = Main hierarchy
-- Container type 4 = Measurement point
-- parent ID = Main hierarchy parent element
-- reference ID = 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_hiepts')
	DROP VIEW skfuser1.cas_hiepts;
	
Create view cas_hiepts as
Select 
	pt.TreeElemID POINTID,
	pt.HierarchyID ROUTEID,
	mac.MACHINENAME,
	pt.Name POINTNAME,
	pt.DESCRIPTION,
	pt.ParentID,
	pt.ReferenceID REFPOINT,
	skfuser1.cas_IsConditionnal(pt.referenceid) CONDPOINT,
	skfuser1.cas_GetCondPointRefPoint(pt.referenceid) DEPENDS_ON_POINT
	
from 
	treeelem pt
	join cas_hiemac mac on mac.MACHINEID=pt.parentid
	
where 
	pt.hierarchytype = 1 
	and pt.containertype=4
	and pt.parentid <> 2147000000

		