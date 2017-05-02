
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
		  when mearea.EXDWORDVAL1=2021 then 'HF'
		  	-- Alarmes scalaires
	      --when ins.ALARMMETHOD=0 then ''
	      -- Niveau
	      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE<ins.ALERTHI then 'OK'
		  when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.ALERTHI then 'ALERT'
	      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.DANGERHI then 'DANGER'
	      -- Zone Id�ale
		  when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<ins.ALERTHI and mearea.OVERALLVALUE>ins.ALERTLO then 'OK'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.ALERTHI then 'ALERT'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.DANGERHI then 'DANGER'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.ALERTLO then 'ALERT'
	      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.DANGERLO then 'DANGER'
	      -- Zone Danger
		  when ins.ALARMMETHOD=2 and (mearea.OVERALLVALUE>ins.DANGERHI or mearea.OVERALLVALUE<ins.DANGERLO) then 'OK'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.ALERTHI and mearea.OVERALLVALUE>=ins.ALERTLO then 'DANGER'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.DANGERHI and mearea.OVERALLVALUE>ins.ALERTHI then 'ALERT'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.ALERTLO and mearea.OVERALLVALUE>=DANGERLO then 'ALERT'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.DANGERLO then 'OK'
	      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE>ins.DANGERHI then 'OK'
	      -- Alarmes d'inspection
	      when ins.ALARMMETHOD is NULL then skfuser1.cas_GetInspectorAlarmStatus(ins.UM, mearea.EXDWORDVAL1, ins.ALARMTEXT1, ins.ALARMTEXT2, ins.ALARMTEXT3, ins.ALARMTEXT4, ins.ALARMTEXT5)      
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



