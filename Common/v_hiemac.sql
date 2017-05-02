-- HIERARCHY MACHINES
-- Hierarchy type 1 = Main hierarchy
-- Container type 3 = Machine
-- parent ID = Main hierarchy group id

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_hiemac')
	DROP VIEW skfuser1.cas_hiemac;
CREATE VIEW cas_hiemac as
Select 
	treeelemid MACHINEID,
	name MACHINENAME,
	parentid PARENTID
from 
	treeelem 
where 
	treeelem.hierarchytype = 1 
	and containertype=3;