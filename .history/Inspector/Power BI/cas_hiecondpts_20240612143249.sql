/*===============================================================
|  Titre: Paramètres des points conditionnels dans les routes
|  Goal:  Aller chercher les critères qui déclenchent un point 
|         conditionnel d'une route d'inspection 
*/

Select 
    -- Point de mesure de la route
    pt.TreeElemID POINTID,
	pt.HierarchyID ROUTEID,
	mac.MACHINENAME,
	pt.Name POINTNAME,
	pt.DESCRIPTION,
	pt.ParentID,
    -- Point déclencheur
	pt.ReferenceID REFPOINT,
    -- Valide si point de route est un point conditionnel 
	CASE WHEN cp.valuestring IS NULL THEN 'FALSE' else 'TRUE' end CONDPOINT,
    -- Critère de déclencheur
	cp.valuestring DEPENDS_ON_POINT,
	CASE 
		WHEN cpc.valuestring = 21500 THEN 'En alarme'
		WHEN cpc.valuestring = 21501 THEN 'Hors alarme'
		WHEN cpc.valuestring = 21502 THEN 'Au dessus'
		WHEN cpc.valuestring = 21503 THEN 'En dessous'
		WHEN cpc.valuestring = 21504 THEN 'Dans la plage'
		WHEN cpc.valuestring = 21505 THEN 'Hors plage'
		WHEN cpc.valuestring = 21506 THEN 'Est égal'
		WHEN cpc.valuestring = 21507 THEN 'Pas égal'
		ELSE NULL
	END COND_CRITERIA,
    -- Valeurs de déclenchement
	cpv.valuestring "CHOIX",
	cpv1.valuestring "LIMITE",
	cpv2.valuestring "LIMITE BASSE",
	cpv3.valuestring "LIMITE HAUTE"
	
from 
    -- Point de hiérarchie référencé dans la route (REFERENCEID)
    join treeelem pt
    -- Equipement parent du point de la hiérarchie
	join cas_hiemac mac on mac.MACHINEID=pt.parentid
    -- Point déclencheur
	join POINT cp on cp.elementid=pt.treeelemid and cp.fieldid=287 and cp.valuestring <> '0'
    -- Critère de déclenchement
	join POINT cpc on cpc.elementid=pt.treeelemid and cpc.fieldid=288 and cpc.valuestring <> '0'
    -- Valeurs de déclenchement pour liste de choix
	LEFT join POINT cpv on cpv.elementid=pt.treeelemid and cpv.fieldid=291 and cpv.valuestring IS NOT NULL -- No. du choix pour "Est égal" et "N'est pas égal" 
    -- Valeur limite de déclenchement
	LEFT join POINT cpv1 on cpv1.elementid=pt.treeelemid and cpv1.fieldid=292 and cpv1.valuestring IS NOT NULL -- Valeur pour "au dessus" et "en dessous"
    -- Valeur minimum pour déclenchement
	LEFT join POINT cpv2 on cpv2.elementid=pt.treeelemid and cpv2.fieldid=289 and cpv2.valuestring IS NOT NULL -- Valeur MIN pour "Dans la plage"
    -- Valeur maximum pour déclenchement
	LEFT join POINT cpv3 on cpv3.elementid=pt.treeelemid and cpv3.fieldid=290 and cpv3.valuestring IS NOT NULL -- Valeur MAX pour "Dans la plage"
	
where 
    -- Hiérarchie
	pt.hierarchytype = 1
    -- Point            
	and pt.containertype=4    
    -- Exclure les points supprimés
	and pt.parentid <> 2147000000