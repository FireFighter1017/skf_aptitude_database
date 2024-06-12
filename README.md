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

### <ins>ROUTEHDR</ins>
General route specific information
  
### <ins>TREEELEM</ins>
Hierarchical elements.  Contains all route points, machine, workspaces and hierarchies.  It also holds the route names and alert indices.
 
 #### HierarchyID  		
 * 1 = Main hierarchy
 * 2 = Routes
 * 3 = Workspaces
 * 4 = Templates

#### CONTAINERTYPE
* 1 = Hierarchy
* 2 = Folder
* 3 = Machine
* 4 = Point

#### ParentID
* 2147000000 = Deleted and should always be excluded

#### ParentRefid
* If in a route, will point to the parentid in the hierarchy

#### ReferenceID
* When in a route, references the hierarchy point used for this route point

### <ins>POINT</ins>
Contains parameters for a measuring point like triggers for a conditionnal point

#### Conditionnal points
The conditions are stored in POINT table and can bel linked with the field `ReferenceID` of table `TREEELEM`:
- *FieldID* = 287, 
	- *valuestring* = Point that will trigger this conditionnal point data collection
- *FieldID* = 288, 
	- *valuestring* = criteria used to trigger the measurement:
		- 21500: In alarm, choice or number (no other values needed)
		- 21501: Not in alarm, choice or number (no other values needed)
		- 21502: Over, number (must have threshold value, 292)
		- 21503: Under, number (must have threshold value, 292)
		- 21504: In range, number (must have min/max values, 289, 290)
		- 21505: Out of range, number (must have min/max values, 289, 290)
		- 21506: Equals, choice (must have selected value, 291)
		- 21507: Does not equal, choice (must have a selected value, 291)
- *FieldID* = 291, 
	- *valuestring* = Choice number from the trigger point
- *FieldID* = 292, 
	- *valuestring* = Threshold Over/Under
- *FieldID* = 289, 
	- *valuestring* = Lower limit
- *FieldID* = 290, 
	- *valuestring* = Higher limit
	
	

### FreqSet  
  
#### Relations
Sets of frequencies that can be seen on "Frequency" tab in point properties.  
Each set is assigned to an ElementID which seems to be a `TREEELEMID` from table `TREEELEM`.  
Whenever a frequency set is selected for a point, an entry is created here with ElementID = TreeElemID and FSID = 
  
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

