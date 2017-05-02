-- HIERARCHY MACHINES
-- Hierarchy type 1 = Main hierarchy
-- Container type 3 = Machine
-- parent ID = Main hierarchy group id
-- reference ID = 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_hiemac')
	DROP VIEW skfuser1.cas_rtemac;
	
CREATE VIEW cas_rtemac as
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
	and containertype=3;