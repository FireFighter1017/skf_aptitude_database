Select 
	p.ROUTENAME,p.ROUTEID,
	pointname,point,slotnumber,
	startdts,
	uploaddts,
	operator,
	pctcomplete/100 pctcomplete,
	measid, 
	datadtg COLLECT_TIMESTAMP,
	skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) MeasStatus,
	datadtg COLLECT_TIMESTAMP, p.tag, p.name

from 
	cassecu_rtehis h join 
	cas_rtepts p on p.routeid=h.routeid left JOIN
	measurement mea on mea.pointid = p.refpoint and skfuser1.TO_DATE(datadtg) >= startdts and skfuser1.TO_DATE(datadtg) <= UPLOADDTS
 
where datediff(d, startdts, getdate())<=0
;