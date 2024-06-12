SELECT
	ts.TBLSETNAME AS plantName,
	p.ROUTENAME,
	p.MACHINE_DESCRIPTION AS machineDescription,
	p.MACHINENAME,
	cat.VALUESTR AS pointCategory,
	o.OPERATOR_GROUP,
	o.OPERATOR_NAME,
	p.POINTNAME,
	p.DESCRIPTION AS pointDescription,
	p.slotnumber AS rankInRoute,
	h.STARTDTS AS routeStart,
	h.ENDDTS AS routeEnd,
	h.UPLOADDTS AS routeUpload,
	h.PCTCOMPLETE / 100 AS pctcomplete,
	mea.MEASID,
	skfuser1.cas_GetMeasAlarmStatus(
		p.REFPOINT,
		mea.MEASID
	) AS MeasStatus,
	CASE
		WHEN skfuser1.cas_GetMeasAlarmStatus(
			p.refpoint,
			mea.measid
		)= 'OK' THEN 0
		WHEN skfuser1.cas_GetMeasAlarmStatus(
			p.refpoint,
			mea.measid
		)= 'ALERT' THEN 4
		WHEN skfuser1.cas_GetMeasAlarmStatus(
			p.refpoint,
			mea.measid
		)= 'DANGER' THEN 8
		ELSE 2
	END AS MeasGravity,
	MONTH(
		skfuser1.TO_DATE(mea.DATADTG)
	) AS measMonth,
	DATEPART(
		wk,
		skfuser1.TO_DATE(mea.DATADTG)
	) AS measWeek,
	YEAR(
		skfuser1.TO_DATE(mea.DATADTG)
	) AS measYear,
	p.REFPOINT AS pointId,
	p.POINT AS rtePointId
FROM
	skfuser1.cas_rtehis AS h
INNER JOIN skfuser1.cas_operators AS o ON
	o.OPERATOR_NAME = h.OPERATOR
INNER JOIN skfuser1.cas_rtepts AS p ON
	p.ROUTEID = h.ROUTEID
INNER JOIN skfuser1.TABLESET AS ts ON
	ts.TBLSETID = p.PLANT
LEFT OUTER JOIN skfuser1.MEASUREMENT AS mea ON
	mea.POINTID = p.REFPOINT
	AND skfuser1.TO_DATE(mea.DATADTG)>= h.STARTDTS
	AND skfuser1.TO_DATE(mea.DATADTG)<= h.UPLOADDTS
LEFT OUTER JOIN skfuser1.POINTCAT AS pcat ON
	pcat.ELEMENTID = p.REFPOINT
	AND pcat.PARENTID = 0
LEFT OUTER JOIN skfuser1.CATEGORY AS cat ON
	cat.CATEGORYID = pcat.CATEGORYID
where  routeName='001H-0009' and h.startdts='2022-06-01 02:47:52.000'