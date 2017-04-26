-- ROUTE POINTS
-- Hierarchy type 2 = route hierarchy
-- Container type 4 = measurement point
-- parent ID = Route hierarchy parent element
-- reference ID = 
drop view cas_rtepts;
Create view cas_rtepts as
Select 
	rt.name ROUTE,
	pt.TreeElemID POINT,
	pt.HierarchyID ROUTEID,
	mac.NAME MACHINE_NAME,
	pt.Name POINT_NAME,
	pt.DESCRIPTION,
	pt.ParentID,
	pt.ReferenceID REF_POINT
from 
	treeelem pt
	join cas_rtehdr rt on rt.ROUTEID=pt.HIERARCHYID
	join cas_rtemac mac on mac.ROUTEID=rt.ROUTEID and mac.ID=pt.parentid
where 
	pt.hierarchytype = 2 
	and pt.containertype=4
	and pt.parentid <> 2147000000

		