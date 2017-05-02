if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_rtehdr')
	DROP VIEW skfuser1.cas_rtehdr;
	
CREATE VIEW cas_rtehdr AS (
select 
	ROUTEHDR.ELEMENTID ROUTEID,
	tableset.tblsetname, 
	Treeelem.NAME ROUTENAME,
	treeelem.description ROUTE_DESCRIPTION,
	convert(DATETIME, substring(routehdr.NEXTSCHEDULE,1,8)) as NEXTSCHED, 
	ROUTEHDR.SCHEDULE/86400 FREQUENCE,
	convert(DATETIME, substring(ROUTEHDR.LASTUPLOADED,1,8)) as LASTUPLOAD,
	convert(DATETIME, substring(ROUTEHDR.LASTDOWNLOADED,1,8)) as LASTDOWNLOAD
	
From 
	ROUTEHDR 
	join treeelem on treeelemid=elementid
	join tableset on tableset.tblsetid = ROUTEHDR.tblsetid
		
);