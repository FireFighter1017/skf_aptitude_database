# skf aptitude database
Notes and scripts for SKF Aptitude Database

## Notice
This is intended for development of Excel reports or any other kind of data analysis based on SKF Aptitude Database.
This must not be used to reverse engineer or spy on SKF aptitude analyst system.

## Database description

The database is an **MS SQL** database used primarily for Vibration Analysis of rotating equipment.
The concepts explained here are related to the following:

- Vibration data collection routes
- Vibration measurement points specifications
- Equipment Hierarchy
- Microlog Inspector Routes
- Vibration and Inspector measurements


TABLES
=========

###RouteHdr
General route specific information
  
###TreeElem 
Hierarchical elements.  Contains all route points, machine, workspaces and hierarchies.  It also holds the route names and alert indices.
####HierarchyID  
1 = Main Hierarchy
2 = Templates
                   
###FreqSet  
  
####Relations
Sets of frequencies that can be seen on "Frequency" tab in point properties.  
Each set is assigned to an EID which seems to be an Element from TreeElem table.  
Whenever a frequency set is selected for a point, an entry is created here with EID = TreeElemID and FSID = 
  
                   Must be merged on `ROUTEHDR` on fields `TREEELEMID` and `ELEMENTID`.  
                   Must filter on field ```HIERARCHYTYPE=2``` which means it is a route.

SCRIPTS 
=========

  Route Header Info:  

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

  Route Points General Information  :  
  
      Select 
      	* 
      from 
      	treeelem 
      where 
      	treeelem.hierarchytype = 2 
      	and containertype=4

