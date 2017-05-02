if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='cassecu_rtehis')
	DROP VIEW skfuser1.cassecu_rtehis;
	;
CREATE VIEW skfuser1.cassecu_rtehis AS
Select
  *
from 
  cas_rtehis
where
  operator in (select operator_name from cas_operators where operator_group='SECURITE')