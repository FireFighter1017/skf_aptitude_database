USE [skfuser]
GO

/****** Object:  UserDefinedFunction [skfuser1].[CAS_FNC_RteMeasByDate]    Script Date: 2016-06-03 09:29:55 ******/
DROP FUNCTION [skfuser1].[CAS_FNC_RteMeasByDate]
GO

/****** Object:  UserDefinedFunction [skfuser1].[CAS_FNC_RteMeasByDate]    Script Date: 2016-06-03 09:29:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [skfuser1].[CAS_FNC_RteMeasByDate] (@RteName varchar(240), @Date Date)  
RETURNS TABLE  
AS  
RETURN   
(

Select



-- INSPECTION
	ins.[CHOIX/ALARMES],
	datadtg,
	CAST(substring(mea.datadtg,1,8) as DATE) "Date Inspect�",
	concat(substring(mea.datadtg,9,2),':',substring(mea.datadtg,11,2),':',substring(mea.datadtg,13,2)) "Hr Coll.",

-- MEASURED STATE
    CASE
      -- Aucune mesure
	  when mea.DATADTG is null then 'NC'
	  when mearea.EXDWORDVAL1=2021 then 'HF'
	  -- Alarmes scalaires
      --when ins.ALARMMETHOD=0 then ''
      -- Niveau
      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE<ins.NIV_ALERTE_HAUT then 'OK'
	  when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.NIV_ALERTE_HAUT then 'ALERTE'
      when ins.ALARMMETHOD=1 and mearea.OVERALLVALUE>=ins.NIV_DANGER_HAUT then 'DANGER'
      -- Zone Id�ale
	  when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<ins.NIV_ALERTE_HAUT and mearea.OVERALLVALUE>ins.NIV_ALERTE_BAS then 'OK'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.NIV_ALERTE_HAUT then 'ALERTE'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE>=ins.NIV_DANGER_HAUT then 'DANGER'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.NIV_ALERTE_BAS then 'ALERTE'
      when ins.ALARMMETHOD=3 and mearea.OVERALLVALUE<=ins.NIV_DANGER_BAS then 'DANGER'
      -- Zone Danger
	  when ins.ALARMMETHOD=2 and (mearea.OVERALLVALUE>ins.NIV_DANGER_HAUT or mearea.OVERALLVALUE<ins.NIV_DANGER_BAS) then 'OK'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.NIV_ALERTE_HAUT and mearea.OVERALLVALUE>=ins.NIV_ALERTE_BAS then 'DANGER'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<=ins.NIV_DANGER_HAUT and mearea.OVERALLVALUE>ins.NIV_ALERTE_HAUT then 'ALERTE'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.NIV_ALERTE_BAS and mearea.OVERALLVALUE>=NIV_DANGER_BAS then 'ALERTE'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE<ins.NIV_DANGER_BAS then 'OK'
      when ins.ALARMMETHOD=2 and mearea.OVERALLVALUE>ins.NIV_DANGER_HAUT then 'OK'
      -- Alarmes d'inspection � valeur unique
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=4 then 'DANGER'
	  -- Alarmes d'inspection � valeurs multiples
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=4 then 'DANGER'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=4 then 'DANGER'
	  -- 1er et 2e choix (1+2=3)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=4 then 'DANGER'
	  -- 1er et 3e choix (1+4=5)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=4 then 'DANGER'
	  -- 1er et 4e choix (1+8=9)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=4 then 'DANGER'
	  -- 1er et 5e choix (1+16=17)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=4 then 'DANGER'
	  -- 2e et 3e choix  (2+4=6)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=4 then 'DANGER'
	  -- 2e et 4e choix  (2+8=10)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=4 then 'DANGER'
	  -- 2e et 5e choix  (2+16=18)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=4 then 'DANGER'
	  -- 3e et 4e choix  (4+8=12)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER'
	  -- 3e et 5e choix  (4+16=20)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=4 then 'DANGER'
	  -- 4e et 5e choix  (8+16=32)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER'
	  
	  else 'N/A'
	END "�tat Mesure",

-- ALARM CARACTERIZATION
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
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=3 then 'ALERTE-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lection unique' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_5=4 then 'DANGER-'+ins.TEXTE_5
	  -- Alarmes d'inspection � valeurs multiples
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 1 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 2 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 4 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 8 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=2 then 'OK'
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=3 then 'ALERTE-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 16 and ins.TEXTE_ALARME_5=4 then 'DANGER-'+ins.TEXTE_5
	  -- 1er et 2e choix (1+2=3)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=2 then 'OK'+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 3 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_2
	  -- 1er et 3e choix (1+4=5)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=2 then 'OK'+'-'+ins.TEXTE_2
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 5 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_3
	  -- 1er et 4e choix (1+8=9)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_1+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 9 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_1+'-'+ins.TEXTE_4
	  -- 1er et 5e choix (1+16=17)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 17 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4+'-'+ins.TEXTE_5
	  -- 2e et 3e choix  (2+4=6)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=2 then 'OK'+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_3
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 6 and ins.TEXTE_ALARME_1=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_3
	  -- 2e et 4e choix  (2+8=10)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 10 and ins.TEXTE_ALARME_2=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_4
	  -- 2e et 5e choix  (2+16=18)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=3 then 'ALERTE-'+ins.TEXTE_2+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 18 and ins.TEXTE_ALARME_3=4 then 'DANGER-'+ins.TEXTE_2+'-'+ins.TEXTE_5
	  -- 3e et 4e choix  (4+8=12)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_3+'-'+ins.TEXTE_4
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_3+'-'+ins.TEXTE_4
	  -- 3e et 5e choix  (4+16=20)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_3+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 20 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_3+'-'+ins.TEXTE_5
	  -- 4e et 5e choix  (8+16=32)
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=2 then 'OK'+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=3 then 'ALERTE-'+ins.TEXTE_4+'-'+ins.TEXTE_5
      when ins.ALARMMETHOD is NULL and ins.UM='S�lections multiples' and mearea.EXDWORDVAL1 = 12 and ins.TEXTE_ALARME_4=4 then 'DANGER-'+ins.TEXTE_4+'-'+ins.TEXTE_5
	  when ins.ALARMMETHOD is null and mearea.EXDWORDVAL1=2021 then 'Machine � l''arr�t'
	  else 'Ok*'
	END "Alarme"
	,ins.UM
	,ALARMMETHOD
	,exdwordval1
	,OVERALLVALUE
	,TEXTE_ALARME_1
	,TEXTE_ALARME_2
	,TEXTE_ALARME_3
	,TEXTE_ALARME_4
	,TEXTE_ALARME_5
	,rtehie.rte_POINTID
	,rtehie.rte_MACHINE_RANK
	,rtehie.rte_POINT_RANK


FROM

	-- Historique des routes
	ROUTEHISTORY rtehis

	-- ROUTES
	join cas_ROUTE rtehie on rtehie.rte_ID=rtehis.ROUTEID

	-- ALARMES
	join cas_INSPECTIONS ins on ins.POINTID=rtehie.rte_POINT_REFERENCEID

-- Measurement header
   left join measurement mea on mea.DATADTG between rtehis.STARTDTS and rtehis.ENDDTS and mea.pointid=rte_POINT_REFERENCEID

-- Readings
   left join measreading mearea on mearea.MEASID = mea.MEASID

WHERE
	/* EXCLURE LE POINTS CONDITIONNELS NON-COLLECT�S PARCE QUE CONDITION NON-RENCONTR�E */
	mearea.EXDWORDVAL1<>2019

	/* ROUTES PKF */
    and rte_name = @RteName

    /* S�LECTION DE DATES d'HISTORIQUE DE ROUTE */
    and CAST(substring(startdts,1,8) as DATE) = @Date

)
;

GO


