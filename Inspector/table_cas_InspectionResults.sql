--INSERT into cas_MeasStatus
Select 
	ts.TBLSETNAME plantName,
	p.ROUTENAME routeName,
	p.MACHINE_DESCRIPTION machineDescription,
	p.MACHINENAME machineName,
	cat.VALUESTR pointCategory,
	p.POINTNAME pointName,
	p.DESCRIPTION pointDescription,
	p.slotnumber rankInRoute,
	h.startdts routeStart,
	h.ENDDTS routeEnd,
	h.uploaddts routeUpload,
	pctcomplete/100 pctcomplete,
	mea.MEASID measId,
	-- Fonction Cascades qui retourne l'état de la mesure au moment de la collecte
	skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) MeasStatus,
	CASE 
		WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) = 'OK' THEN 0
		WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) = 'ALERT' THEN 4
		WHEN skfuser1.cas_GetMeasAlarmStatus(p.refpoint, mea.measid) = 'DANGER' THEN 8
		ELSE 2
	END MeasGravity,
	month(skfuser1.TO_DATE(mea.DATADTG)) measMonth,
	datepart(wk, skfuser1.TO_DATE(mea.datadtg)) measWeek,
	year(skfuser1.TO_DATE(mea.datadtg)) measYear

	into cas_measStatus


from
	-- Vue Cascades sur les routes de sécurité de Services et Achats
	cas_rtehis h JOIN
	-- Vue Cascades des opérateurs
	cas_operators o on o.OPERATOR_NAME=h.OPERATOR JOIN
	-- Vue Cascades sur les points des routes
	cas_rtepts p on p.routeid=h.routeid JOIN
	-- Table des hiérarchies
	tableset ts on ts.tblsetid=p.plant left JOIN
	-- Table des mesures collectées entre le début de la route et le téléversement de la route
	measurement mea on mea.pointid = p.refpoint and skfuser1.TO_DATE(datadtg) >= startdts and skfuser1.TO_DATE(datadtg) <= UPLOADDTS
	-- Table des categories de machines
	left join 
	pointcat pcat on pcat.ELEMENTID=p.REFPOINT
	left join
	category cat on cat.CATEGORYID=pcat.CATEGORYID
 
where 
	/*** FILTRES STANDARDS ***/
	-- Période désirée
	datediff(wk, startdts, getdate())=2


