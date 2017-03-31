-- ROUTE POINTS
-- Hierarchy type 2 = route hierarchy
-- Container type 4 = measurement point
-- parent ID = Route hierarchy parent element
-- reference ID = 
Select 
	* 
from 
	treeelem 
where 
	treeelem.hierarchytype = 2 and containertype=4
		