/*===============================================================
|  Title: Route machines
|  Goal:  List all inspection routes 
|         with their respective points
|                                  
*/
DROP view [skfuser1].[cas_rtemac]
;
CREATE view [skfuser1].[cas_rtemac] as

Select 
	treeelemid MACHINEID,
	name MACHINENAME,
	description,
	parentid PARENTID,
	slotnumber
from 
	treeelem 
where 
	treeelem.hierarchytype = 2 
    -- Machines
	and containertype=3;