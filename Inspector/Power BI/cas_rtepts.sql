/*===============================================================
|  Title: Route points structure
|  Goal:  List all inspection routes 
|         with their respective points
|                                  
*/

Select 
	rt.routename ROUTENAME,
	pt.TreeElemID POINT,
	pt.HierarchyID ROUTEID,
	mac.MACHINENAME MACHINENAME,
	mac.description MACHINE_DESCRIPTION,
	pt.Name POINTNAME,
	pt.DESCRIPTION,
	pt.ParentID,
	pt.ReferenceID REFPOINT,
	h.TBLSETID PLANT,
	mac.slotnumber, 
    h.name, 
    tag.tag, 
    pt.slotnumber PointSequence
	
from 
	treeelem pt
	join cas_rtehdr rt on rt.ROUTEID = pt.HIERARCHYID
	join cas_rtemac mac on mac.MACHINEID = pt.parentid
	join treeelem h on h.treeelemid=pt.parentrefid
	left join marlinlocationtag tag on tag.elementid=h.treeelemid
	
where 
    -- Route d'inspection
	pt.hierarchytype = 2 
    -- Point d'inspection
	and pt.containertype=4
    -- N'est pas un template
	and pt.parentid <> 2147000000
    -- N'est pas une fin de route
	and pt.name<>'FIN DE ROUTE'