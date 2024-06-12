DROP view [skfuser1].[cas_rtepts]
;
CREATE view [skfuser1].[cas_rtepts_with_tags] as
;
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
	mac.slotnumber, h.name, tag.tag, pt.slotnumber PointSequence, pt.parentrefid
from 
	treeelem pt
	join cas_rtehdr rt on rt.ROUTEID = pt.HIERARCHYID
	join cas_rtemac mac on mac.MACHINEID = pt.parentid
	join treeelem h on h.treeelemid=pt.parentrefid
	left join marlinlocationtag tag on tag.elementid=h.treeelemid
	
	
where 
	pt.hierarchytype = 2 
	and pt.containertype=4
	and pt.parentid <> 2147000000
	and skfuser1.cas_IsConditionnal(pt.referenceid)=0
	and pt.name<>'FIN DE ROUTE'
	