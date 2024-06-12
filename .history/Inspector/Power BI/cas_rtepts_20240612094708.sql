/*
##===============================================================
##  Title: Route points structure
##  Goal:  List all inspection routes 
##         with their respective points

*/
Select 
	pt.TreeElemID POINTID,
	pt.HierarchyID ROUTEID,
	mac.MACHINENAME,
	pt.Name POINTNAME,
	pt.DESCRIPTION,
	pt.ParentID,
	pt.ReferenceID REFPOINT,
	CASE WHEN valuestring IS NULL THEN 'FALSE' else 'TRUE' end CONDPOINT,
	valuestring DEPENDS_ON_POINT
	
from 
	treeelem pt
	join cas_hiemac mac on mac.MACHINEID=pt.parentid
	left join POINT on elementid=pt.treeelemid and fieldid=287 and valuestring <> '0'

	
where 
	pt.hierarchytype = 1 
	and pt.containertype=4
	and pt.parentid <> 2147000000