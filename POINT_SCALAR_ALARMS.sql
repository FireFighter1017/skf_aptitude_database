Select
	treeelem.name,
	scalaralarm.*
	
FROM
	SCALARALARM
	join treeelem on elementid=treeelemid and containertype=4 and hierarchytype=1