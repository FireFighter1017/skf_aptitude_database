-- HIERARCHY MACHINES
-- Hierarchy type 1 = Main hierarchy
-- Container type 3 = Machine
-- parent ID = Main hierarchy group id
-- reference ID = 
Select 
	* 
from 
	treeelem 
where 
	treeelem.hierarchytype = 1 
	and containertype=3
	