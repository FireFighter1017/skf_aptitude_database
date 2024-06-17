-- skfuser1.cas_Inspections source
DROP VIEW skfuser1.cas_Inspections
;
CREATE VIEW skfuser1.cas_Inspections AS


Select
	hiepts.POINTID,
	hiepts.POINTNAME ,
	msg.[Pre-Instruc. Content] "Instruc. Prealables",
	ptum.UM "UM",

-- TEXTE
	ISNULL(ia.PROMPT,'PRENDRE MESURE') "Tache",

-- CHOIX et NIVEAUX D'ALARMES

	-- CHOIX D'INSPECTION
	ia.INSPECTIONTEXT1 TEXT1,
	ia.INSPECTIONTEXT2 TEXT2,
	ia.INSPECTIONTEXT3 TEXT3,
	ia.INSPECTIONTEXT4 TEXT4,
	ia.INSPECTIONTEXT5 TEXT5,
	ia.ALARMLEVEL1 ALARMTEXT1,
	ia.ALARMLEVEL2 ALARMTEXT2,
	ia.ALARMLEVEL3 ALARMTEXT3,
	ia.ALARMLEVEL4 ALARMTEXT4,
	ia.ALARMLEVEL5 ALARMTEXT5,
	-- VALEURS ALARMES DE NIVEAU
	sa.DANGERHI,
	sa.ALERTHI,
	sa.ALERTLO,
	sa.DANGERLO,

	CASE
		when sa.ALARMMETHOD = 0 then cast('' as NVARCHAR)
		when sa.ALARMMETHOD = Null then cast('NoAlarmDefined' as NVARCHAR)
		when sa.ALARMMETHOD in (1,2,3) and sa.ENABLEALERTHI + sa.ENABLEALERTLO + sa.ENABLEDANGERHI + sa.ENABLEDANGERHI + sa.ENABLEDANGERLO = 0 then ''
		when sa.ALARMMETHOD = 1 then -- Alarmes de niveau
			CAST(
				'OK: <' + ltrim(str(sa.ALERTHI)) + char(10) +
				'Alerte: (' + ltrim(str(sa.ALERTHI)) + '...' + ltrim(str(sa.DANGERHI)) + ')' +  char(10) +
				'Danger: >=' + ltrim(str(sa.DANGERHI))
			AS NVARCHAR)
		when sa.ALARMMETHOD = 2 then -- Alarmes de Zone Danger
			CAST(
				'OK: <' + ltrim(str(sa.DANGERLO)) + ' ou ' + '>' +  ltrim(str(sa.DANGERHI)) + char(10) +
				'Alerte: (' + ltrim(str(sa.DANGERLO)) + '...' + ltrim(str(sa.ALERTLO)) + ') ou (' + ltrim(str(sa.ALERTHI)) + '...' +ltrim(str(sa.DANGERHI)) + ')' + char(10) +
				'Danger: (' + ltrim(str(sa.ALERTLO)) + '...' + ltrim(str(sa.ALERTHI)) + ')'
			AS NVARCHAR)
		when sa.ALARMMETHOD = 3 then -- Alarmes de Zone Id�ale
			CAST(
				'Ok: (' + ltrim(str(sa.ALERTLO)) + '...' + ltrim(str(sa.ALERTHI)) + ')' + char(10) + 
				'Alerte: (' + ltrim(str(sa.DANGERLO)) + '...' + ltrim(str(sa.ALERTLO)) + ') ou (' + ltrim(str(sa.ALERTHI)) + '...' +ltrim(str(sa.DANGERHI)) + ')' + char(10) +
				'Danger: <' + ltrim(str(sa.DANGERLO)) + ' ou ' + '>' +  ltrim(str(sa.DANGERHI))
			AS NVARCHAR)
		when sa.ALARMMETHOD is null then
			CAST(
					ia.INSPECTIONTEXT1 + '(' + CASE ia.ALARMLEVEL1 WHEN 2 then 'Correct' when 3 then 'Alerte' when 4 then 'Danger' else 'Aucun' end + ')' + char(10) + 
					ia.inspectiontext2 + '(' + CASE ia.ALARMLEVEL2 WHEN 2 then 'Correct' when 3 then 'Alerte' when 4 then 'Danger' else 'Aucun' end + ')' + char(10) + 
					ia.inspectiontext3 + '(' + CASE ia.ALARMLEVEL3 WHEN 2 then 'Correct' when 3 then 'Alerte' when 4 then 'Danger' else 'Aucun' end + ')' + char(10) + 
					ia.inspectiontext4 + '(' + CASE ia.ALARMLEVEL4 WHEN 2 then 'Correct' when 3 then 'Alerte' when 4 then 'Danger' else 'Aucun' end + ')' + char(10) + 
					ia.inspectiontext5 + '(' + CASE ia.ALARMLEVEL5 WHEN 2 then 'Correct' when 3 then 'Alerte' when 4 then 'Danger' else 'Aucun' end + ')' AS NVARCHAR(MAX))
	END CHOICES_AND_ALARMS,

	CASE sa.ALARMMETHOD
		when 0 then 'Num. Aucune Alarme'
		when 1 then 'Num. Alarme de Niveau'
		when 2 then 'Num. Alarme de Zone Danger'
		when 3 then 'Num. Alarme Hors Cible'
		else 'Inspection'
	end ALARM_TYPE,

-- MESSAGES
	msg."alert summary" ALERT_MSG,
	msg."danger summary" DANGER_MSG,

-- ACTIONS OF CONDITIONNAL POINTS
	CAST(
		cdptia.INSPECTIONTEXT1 + '(' + rtrim(str(cdptia.ALARMLEVEL1)) + ')' + char(10) + 
		cdptia.inspectiontext2 + '(' + rtrim(str(cdptia.ALARMLEVEL2)) + ')' + char(10) + 
		cdptia.inspectiontext3 + '(' + rtrim(str(cdptia.ALARMLEVEL3)) + ')' + char(10) + 
		cdptia.inspectiontext4 + '(' + rtrim(str(cdptia.ALARMLEVEL4)) + ')' + char(10) + 
		cdptia.inspectiontext5 + '(' + rtrim(str(cdptia.ALARMLEVEL5)) + ')' AS NVARCHAR) ACTIONS,
	
	ALARMMETHOD


from
	cas_hiepts hiepts		--// POINTS
	--// Type DAD: MARLIN/Microlog Inspector
	join point inspts on inspts.elementid=hiepts.pointid and fieldid=912 and valuestring=376
-- Messages
	left join (		--// Inspection Parameters
		select distinct
			ti.SUMMARY "Pre-Instruc. Summary",
			ti.CONTENT "Pre-Instruc. Content",
            ta.summary "alert summary",
            ta.content "alert content",
            td.summary "danger summary",
            td.content "danger content",
            ma.ownerid

		from
		 
		 -- Table de relation entre les messages et les points
            messageassign ma
			full outer join
         
		 -- Pre-inspection Messages
			(select
               ma.ownerid,
               msg.summary,
               msg.content
             from message msg
               join messageassign ma on ma.messageid=msg.messageid and ma.contextid=302) ti on ti.ownerid=ma.ownerid

		 -- Alert Message
			full outer join
		 
			(select
               ma.ownerid,
               msg.summary,
               msg.content
             from message msg
               join messageassign ma on ma.messageid=msg.messageid and ma.contextid=305) ta on ta.ownerid=ma.ownerid
         -- Danger Messages   
			full outer join 
            (select
               ma.ownerid,
               msg.summary,
               msg.content
             from message msg
               join messageassign ma on ma.messageid=msg.messageid and ma.contextid=306) td on td.ownerid=ma.ownerid
            
         ) msg on msg.ownerid=hiepts.POINTID

-- Answer Values for single or multiple inspections
	left join inspectionalarm ia on ia.ELEMENTID=hiepts.POINTID

-- Alert levels for scalar alarms
   -- Alarm method 0 = No alarm
   -- Alarm method 1 = Level
   -- Alarm method 2 = Danger Zone
   -- Alarm method 3 = Target Zone
	left join scalaralarm sa on sa.ELEMENTID=hiepts.POINTID

-- Point units of measure
	left join (select elementid, valuestring "UM" from point join registration on registrationid=fieldid where signature='SKFCM_ASPF_Full_Scale_Unit') ptum on ptum.elementid=hiepts.POINTID

/* Conditionnal points */
	left join (select elementid, valuestring "CondPT" from point where fieldid=287 and valuestring>0 /* Conditionnal point*/) cdptid on cdptid.elementid=hiepts.POINTID
	left join TREEELEM cdpt on cdpt.TREEELEMID=cdptid.CondPT
	left join INSPECTIONALARM cdptia on cdptia.ELEMENTID=cdpt.TREEELEMID

	;