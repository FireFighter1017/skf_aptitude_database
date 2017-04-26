-- Global Frequency SET
drop view cas_freq;
create view cas_freq as
Select 
	elementid,
	fe.name,
	multiple
from 
	FREQASSIGN fa JOIN
	FREQSET fs on fs.fsid=fa.fsid join
 	FREQENTRIES fe on fe.fsid=fs.fsid
 
 
-- Private Frequency SET

