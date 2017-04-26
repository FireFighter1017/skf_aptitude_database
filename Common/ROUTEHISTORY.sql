Select
  ROUTEID,
  convert(DATETIME, substring(STARTDTS,1,8)) as STRDAT,
  convert(DATETIME, substring(ENDDTS,1,8)) as ENDDAT,
  OPERATOR,
  PCTCOMPLETE
from 
  ROUTEHISTORY