-- ROUTE MACHINES
-- Hierarchy type 2 = Route hierarchy
-- Container type 3 = Machine
-- parent ID = Main hierarchy group id
-- reference ID = 
DROP VIEW cas_rtemac;
CREATE VIEW cas_rtemac as
Select 
	treeelemid ID,
	name NAME,
	parentid PARENTID,
	hierarchyid ROUTEID
from 
	treeelem 
where 
	treeelem.hierarchytype = 2 
	and containertype=3;