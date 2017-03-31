Select 
	* 
From 
	FREQSET fs 
	left join FREQENTRIES fe on fe.fsid=fs.fsid 
where 
	EID in (select treeelemid from treeelem where hierarchytype=1 and containertype=4)