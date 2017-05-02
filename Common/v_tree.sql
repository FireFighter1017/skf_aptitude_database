DROP VIEW cas_tree;
CREATE VIEW cas_tree as 

WITH Tree (Location, ChildName, Childid, parentid, TreeID, TableID)
AS (
	SELECT 
	        	CAST(ISNULL((Select name from TreeElem where TreeElemID=T.ParentID),'') + '\' + T.Name AS VARCHAR(255)) [Path],
	        	Name, 
	        	TreeElemID,
	        	ParentID,
	        	hierarchyid,
	        	'T_Table'
	    		FROM TreeElem T 
	    		Where t.parentid <> 2147000000 and hierarchyid=0
	UNION ALL
	SELECT 
	        	CAST(ISNULL(Tree.Location,'') + '\' + H.Name AS VARCHAR(255)) [Path],
	        	H.Name, 
	        	H.TreeElemID,
	        	H.ParentID,
	        	hierarchyid,
	        	'H_Table'
	    		FROM TreeElem H
	    			  inner join Tree on tree.Childid=h.ParentID
	    		Where h.parentid <> 2147000000
	)

	Select * from Tree 

	