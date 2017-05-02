if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_operators')
	DROP VIEW skfuser1.cas_operators;
create view cas_operators
AS
select 
	o.names OPERATOR_NAME,
	os.NAME OPERATOR_GROUP
from skfuser1.OPERNAMES o join operatorsetassign oa on o.operid=oa.operatorid join operatorset os on os.operatorsetid=oa.operatorsetid;
