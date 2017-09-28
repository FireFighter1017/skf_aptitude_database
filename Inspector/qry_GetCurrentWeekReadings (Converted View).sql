--// FAILS WITH UNREADABLE Date Time value from Strings

Select 
	tblsetname 			ROUTENAME,
	rhdr.elementid 		ROUTEID,
	pt.name 			pointname,
	pt.treeelemid 		point,
	mac.slotnumber 		slotnumber,
	h.startdts, --skfuser1.TO_DATE(h.startdts) 	START_TIMESTAMP,
	--skfuser1.TO_DATE(h.uploaddts) SYNCH_TIMESTAMP,
	oper.names 			OPERATOR,
	opset.name 			OPERATOR_GROUP,
	h.pctcomplete/100	pctcomplete,
	datadtg 			COLLECT_TIMESTAMP,
	skfuser1.cas_GetMeasAlarmStatus(pt.referenceid, mea.measid) MeasStatus,
	tag.tag 			MACHINE_TAG, 
	hmac.name 			MACHINE_NAME

from 
	--// Route History
	ROUTEHISTORY 		h 		
	join OPERNAMES 			oper 	on oper.names 				= operator 
	join operatorsetassign 	opsa 	on opsa.operatorid 		= oper.operid 
	join operatorset 			opset on opset.operatorsetid 	= opsa.operatorsetid 
	
	--// Route Header
	join ROUTEHDR	 			rhdr 	on rhdr.elementid 		= h.routeid 
	join treeelem  			rdet 	on rdet.treeelemid 		= rhdr.elementid 
	join tableset	 			ts 	on ts.tblsetid 			= rhdr.tblsetid 

	--// Route Points
	join treeelem 				pt 	on pt.hierarchyid 		= h.routeid 
	join treeelem  			mac 	on mac.treeelemid 		= pt.parentid 
	join treeelem	 			hmac 	on hmac.treeelemid 		= pt.parentrefid 
	join measurement	 		mea 	on mea.pointid 			= pt.referenceid
												and datadtg >= h.startdts 
												and datadtg <= h.UPLOADDTS
	--// Equipment tag if any
	left join 
	marlinlocationtag tag 	on tag.elementid 			= hmac.treeelemid 
									and tag.tag=rdet.name
 
where 
	
	--// Select points from route hierarchy
	pt.hierarchytype=2 and pt.containertype=4 and pt.parentid <> 2147000000 
	
	--// Exclude conditionnal points
	and skfuser1.cas_IsConditionnal(pt.referenceid)=0
	
	--// Exclude route start and route end points
	and ISNULL(tag.tag,'NO_TAG') 	<> rdet.name
	and pt.name							<>	'FIN DE ROUTE'
	
	--// Retreive specified number of time units.
--	and datediff(d, h.startdts, getdate())<=0
--and h.startdts>='20170507000000'
;