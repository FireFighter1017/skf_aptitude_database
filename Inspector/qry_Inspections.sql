Select

-- History record
	rtehis.ENDDATE "Date",
	CAST(rtehis.STARTDTS as TIME) "Debut",
	CAST(rtehis.ENDDTS as TIME) "Fin",
	datediff(MINUTE,
		STARTDTS,
		ENDDTS
			) "Duree (min.)",
	rtehis.operator "Operateur",
-- ROUTE
	rtepts.ROUTE,
	rtepts.ROUTEID,
	rtepts.MACHINENAME,
	rtepts.POINTNAME,
	rtepts.DESCRIPTION,

-- INSPECTION
	ins.[CHOIX/ALARMES],
	datadtg,
	CAST(substring(mea.datadtg,1,8) as DATE) "Date Inspecte",
	concat(substring(mea.datadtg,9,2),':',substring(mea.datadtg,11,2),':',substring(mea.datadtg,13,2)) "Hr Coll.",

-- ALARM PROCESSING
    CASE
      -- Aucune mesure
	  when mea.DATADTG is null then 'Non-Collect�'
	  -- Alarmes scalaires
      --when ins.ALARMMETHOD=0 then ''
      -- Niveau
      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE<ins.NIV_ALERTE_HAUT then 'OK'
	  when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.NIV_ALERTE_HAUT then 'NIV_ALERTE_HAUT' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.NIV_DANGER_HAUT then 'NIV_DANGER_HAUT' + '(' + str(mearea.OVERALLVALUE) + ')'
      -- Zone Id�ale
	  when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<ins.NIV_ALERTE_HAUT and mearea.OVERALLVALUE>ins.NIV_ALERTE_BAS then 'OK'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.NIV_ALERTE_HAUT then 'NIV_ALERTE_HAUT' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.NIV_DANGER_HAUT then 'NIV_DANGER_HAUT' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.NIV_ALERTE_BAS then 'NIV_ALERTE_BAS' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.NIV_DANGER_BAS then 'NIV_DANGER_BAS' + '(' + str(mearea.OVERALLVALUE) + ')'
      -- Zone Danger
	  when ins.ALARMMETHOD=2 and (mearea.OVERALLVALUE>ins.NIV_DANGER_HAUT or mearea.OVERALLVALUE<ins.NIV_DANGER_BAS) then 'OK'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.NIV_ALERTE_HAUT and mearea.OVERALLVALUE>=ins.NIV_ALERTE_BAS then 'NIV_DANGER' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.NIV_DANGER_HAUT and mearea.OVERALLVALUE>ins.NIV_ALERTE_HAUT then 'NIV_ALERTE_HAUT' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.NIV_ALERTE_BAS and mearea.OVERALLVALUE>=NIV_DANGER_BAS then 'NIV_ALERTE_BAS' + '(' + str(mearea.OVERALLVALUE) + ')'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.NIV_DANGER_BAS then 'OK'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE>ins.NIV_DANGER_HAUT then 'OK'
      -- Alarmes d'inspection � valeur unique
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=3 then 'ALERTE-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=4 then 'DANGER-'+ins.TEXTE_5
	  -- Alarmes d'inspection � valeurs multiples
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=3 then 'ALERTE-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=4 then 'DANGER-'+ins.TEXTE_5
	  -- 1er et 2e choix (1+2=3)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=2 then 'OK'+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_2
	  -- 1er et 3e choix (1+4=5)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=2 then 'OK'+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_3
	  -- 1er et 4e choix (1+8=9)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_4
	  -- 1er et 5e choix (1+16=17)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4+'-'+ins.TEXTE_5
	  -- 2e et 3e choix  (2+4=6)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=2 then 'OK'+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_3
	  -- 2e et 4e choix  (2+8=10)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_4
	  -- 2e et 5e choix  (2+16=18)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_5
	  -- 3e et 4e choix  (4+8=12)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_3+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_3+'-'+ins.TEXTE_4
	  -- 3e et 5e choix  (4+16=20)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_3+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_3+'-'+ins.TEXTE_5
	  -- 4e et 5e choix  (8+16=32)
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='Selections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4+'-'+ins.TEXTE_5
	  when ins.ALARMMETHOD is null and mearea.EXDWORDVAL1=2021 then 'Machine a l''arret'
	END "Alarme"
	,ALARMMETHOD
	,exdwordval1
	,OVERALLVALUE
	,TEXTE_ALARME_1
	,TEXTE_ALARME_2
	,TEXTE_ALARME_3
	,TEXTE_ALARME_4
	,TEXTE_ALARME_5
	,rtepts.POINTID


FROM

	-- Historique des routes
	cas_rtehis rtehis

	-- ROUTES
	join cas_rtepts rtepts on rtepts.ROUTEID=rtehis.ROUTEID

	-- ALARMES
	join cas_INSPECTIONS ins on ins.POINTID=rtepts.REFPOINT

-- Measurement header
   left join measurement mea on mea.DATADTG between rtehis.STARTDTS and rtehis.ENDDTS and mea.pointid=rtepts.REFPOINT

-- Readings
   left join measreading mearea on mearea.MEASID = mea.MEASID

WHERE
   /* ROUTES PKF */
   rtepts.ROUTENAME like '%-0004'

   /* Selection DE DATES d'HISTORIQUE DE ROUTE */
--   and CAST(substring(startdts,1,8) as DATE) = '2016-05-22'

   /* Selection DE MESURES PAR DATES */
--   and CAST(substring(mea.datadtg,1,8) as DATE) = 

order by mea.datadtg asc, rtepts.rte_NAME , rtepts.rte_MACHINE_RANK, rtepts.rte_POINT_RANK
