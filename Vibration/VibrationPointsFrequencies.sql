Select 
	Route,
	Point_name,
	Description,
	Location,
	FREQNAME FREQUENCY,
	FREQTYPE Type
	
	
FROM
	cas_rtepts
	join cas_tree on cas_tree.Childid=cas_rtepts.POINT
	join cas_freq on cas_freq.POINT=cas_rtepts.REF_POINT
