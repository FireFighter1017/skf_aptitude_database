-- ROUTES DESCRIPTION
-- excludes points and history

select 
	tableset.tblsetname, 
	Treeelem.NAME,
	convert(DATETIME, substring(routehdr.NEXTSCHEDULE,1,8)) as NEXTSCHED, 
	ROUTEHDR.SCHEDULE/86400 FREQUENCE,
	convert(DATETIME, substring(ROUTEHDR.LASTUPLOADED,1,8)) as LASTUPLOAD,
	convert(DATETIME, substring(ROUTEHDR.LASTDOWNLOADED,1,8)) as LASTDOWNLOAD
	
From 
	ROUTEHDR 
	join treeelem on treeelemid=elementid
	join tableset on tableset.tblsetid = ROUTEHDR.tblsetid
		
