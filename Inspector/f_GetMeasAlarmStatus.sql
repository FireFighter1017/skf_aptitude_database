
/****** Object:  UserDefinedFunction [skfuser1].[CAS_FNC_RteMeasByDate]    Script Date: 2016-06-03 09:29:55 ******/
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='cas_GetMeasAlarmStatus')
	DROP FUNCTION cas_GetMeasAlarmStatus;
GO

CREATE FUNCTION cas_GetMeasAlarmStatus (@PointId numeric(38,0), @MeasId numeric(38,0)) 

RETURNS varchar(10)
AS  
BEGIN
	Declare @AlarmStatus varchar(10);
	
	Select @AlarmStatus = 
		 
		-- MEASURED STATE
		CASE
	      -- Aucune mesure
		  	when mea.DATADTG is null then 'NoData'
		  	-- Alarmes scalaires
	      --when ins.ALARMMETHOD=0 then ''
	      -- Niveau
	      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE<ins.ALERTHI then 'OK'
		  	when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.ALERTHI then 'ALERTE'
	      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.DANGERHI then 'DANGER'
	      -- Zone Id�ale
		  	when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<ins.ALERTHI and mearea.OVERALLVALUE>ins.ALERTLO then 'OK'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.ALERTHI then 'ALERTE'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.DANGERHI then 'DANGER'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.ALERTLO then 'ALERTE'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.DANGERLO then 'DANGER'
	      -- Zone Danger
		  	when ins.ALARMMETHOD=2 and (mearea.OVERALLVALUE>ins.DANGERHI or mearea.OVERALLVALUE<ins.DANGERLO) then 'OK'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.ALERTHI and mearea.OVERALLVALUE>=ins.ALERTLO then 'DANGER'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.DANGERHI and mearea.OVERALLVALUE>ins.ALERTHI then 'ALERTE'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.ALERTLO and mearea.OVERALLVALUE>=DANGERLO then 'ALERTE'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.DANGERLO then 'OK'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE>ins.DANGERHI then 'OK'
			-- Aucune alarme définie
	      when ins.ALARMMETHOD is NULL 
	      	and ins.UM in ('Sélection unique', 'Single Selection', 'Sélections multiples', 'Multiple Selections') 
	      	and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT1 is NULL then 'OK'
	      when ins.ALARMMETHOD is NULL 
	      	and ins.UM in ('Sélection unique', 'Single Selection', 'Sélections multiples', 'Multiple Selections') 
	      	and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT2 is NULL then 'OK'
	      when ins.ALARMMETHOD is NULL 
	      	and ins.UM in ('Sélection unique', 'Single Selection', 'Sélections multiples', 'Multiple Selections') 
	      	and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT3 is NULL then 'OK'
	      when ins.ALARMMETHOD is NULL 
	      	and ins.UM in ('Sélection unique', 'Single Selection', 'Sélections multiples', 'Multiple Selections') 
	      	and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT4 is NULL then 'OK'
	      when ins.ALARMMETHOD is NULL 
	      	and ins.UM in ('Sélection unique', 'Single Selection', 'Sélections multiples', 'Multiple Selections') 
	      	and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT5 is NULL then 'OK'
	      	
	      -- Alarmes d'inspection à valeur unique
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT1 in (1,2) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT1=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT1=4 then 'DANGER'
	     	when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT2 in (1,2) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT2=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT2=4 then 'DANGER'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT3 in (1,2) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT3=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT3=4 then 'DANGER'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT4 in (1,2) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT4=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT4=4 then 'DANGER'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT5 in (1,2) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT5=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélection unique', 'Single Selection') and mearea.EXDWORDVAL1 in(1,2,4,8,16) and ins.ALARMTEXT5=4 then 'DANGER'
		  	-- Alarmes d'inspection à valeurs multiples
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélections multiples', 'Multiple Selections') and mearea.EXDWORDVAL1 in(1,2,3,4,5,6,8,9,10,12,16,18,20) and ins.ALARMTEXT1 in (1,2,Null) then 'OK'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélections multiples', 'Multiple Selections') and mearea.EXDWORDVAL1 in(1,2,3,4,5,6,8,9,10,12,16,18,20) and ins.ALARMTEXT1=3 then 'ALERTE'
	      when ins.ALARMMETHOD is NULL and ins.UM in ('Sélections multiples', 'Multiple Selections') and mearea.EXDWORDVAL1 in(1,2,3,4,5,6,8,9,10,12,16,18,20) and ins.ALARMTEXT1=4 then 'DANGER'
	      when ins.ALARMMETHOD is null and mearea.EXDWORDVAL1=2021 then 'Machine a l''arret'
		  
		ELSE 'N/A'
		END
	
	
	FROM
		-- INSPECTIONS
		skfuser1.cas_Inspections ins
	
	-- Measurement header
	   left join measurement mea on mea.pointid=ins.POINTID
	
	-- Readings
	   left join measreading mearea on mearea.MEASID = mea.MEASID
	
	WHERE
		/* EXCLURE LE POINTS CONDITIONNELS NON-COLLECTES PARCE QUE CONDITION NON-RENCONTREE */
		mearea.EXDWORDVAL1<>2019
	
		/* PointID received as parameter */
	   and ins.POINTID = @PointId
	   
	   /* Measurement ID received as parameter */
		AND mearea.measid = @MeasID
	;

	RETURN @AlarmStatus;

END



