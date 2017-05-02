if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cas_rtehis')
	DROP VIEW skfuser1.cas_rtehis;
	;
CREATE VIEW skfuser1.cas_rtehis AS
Select
  ROUTEID,
  skfuser1.TO_DATE(startdts) STARTDTS,
  skfuser1.TO_DATE(enddts) ENDDTS,
  CAST(skfuser1.TO_DATE(STARTDTS) as DATE) STARTDAT,
  CAST(skfuser1.TO_DATE(ENDDTS) as DATE) ENDDAT,
  OPERATOR,
  PCTCOMPLETE,
  skfuser1.TO_DATE(UPLOADDTS) UPLOADDTS
from 
  ROUTEHISTORY