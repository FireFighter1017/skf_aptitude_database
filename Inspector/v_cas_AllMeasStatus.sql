USE [skfuser]
GO

/****** Object:  View [skfuser1].[cas_AllMeasStatus]    Script Date: 8/25/2017 13:10:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [skfuser1].[cas_AllMeasStatus]
AS
SELECT        
	ts.TBLSETNAME AS plantName, 
	p.ROUTENAME AS routeName, 
	p.MACHINE_DESCRIPTION AS machineDescription, 
	p.MACHINENAME AS machineName, 
	cat.VALUESTR AS pointCategory, 
	o.OPERATOR_GROUP, 
	o.OPERATOR_NAME, 
	p.POINTNAME AS pointName, 
	p.DESCRIPTION AS pointDescription, 
	p.slotnumber AS rankInRoute, 
	h.STARTDTS AS routeStart, 
	h.ENDDTS AS routeEnd, 
	h.UPLOADDTS AS routeUpload, 
                         h.PCTCOMPLETE / 100 AS pctcomplete, mea.MEASID AS measId, skfuser1.cas_GetMeasAlarmStatus(p.REFPOINT, mea.MEASID) AS MeasStatus, CASE WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, 
                         mea.measid) = 'OK' THEN 0 WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) = 'ALERT' THEN 4 WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) 
                         = 'DANGER' THEN 8 ELSE 2 END AS MeasGravity, MONTH(skfuser1.TO_DATE(mea.DATADTG)) AS measMonth, DATEPART(wk, skfuser1.TO_DATE(mea.DATADTG)) AS measWeek, 
                         YEAR(skfuser1.TO_DATE(mea.DATADTG)) AS measYear, p.refpoint as pointId, p.point as rtePointId
FROM            skfuser1.cas_rtehis AS h INNER JOIN
                         skfuser1.cas_operators AS o ON o.OPERATOR_NAME = h.OPERATOR INNER JOIN
                         skfuser1.cas_rtepts AS p ON p.ROUTEID = h.ROUTEID INNER JOIN
                         skfuser1.TABLESET AS ts ON ts.TBLSETID = p.PLANT LEFT OUTER JOIN
                         skfuser1.MEASUREMENT AS mea ON mea.POINTID = p.REFPOINT AND skfuser1.TO_DATE(mea.DATADTG) >= h.STARTDTS AND skfuser1.TO_DATE(mea.DATADTG) <= h.UPLOADDTS LEFT OUTER JOIN
                         skfuser1.POINTCAT AS pcat ON pcat.ELEMENTID = p.REFPOINT LEFT OUTER JOIN
                         skfuser1.CATEGORY AS cat ON cat.CATEGORYID = pcat.CATEGORYID


GO