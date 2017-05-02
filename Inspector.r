library(RODBC)
library(dplyr)


##===========
## Constants
##-----------
# Container types
CT_ROUTE = 1                 ## Route Header

## Route type
RT_BKP = "0004$"             ## Backup Fire Ext.

## Ask user which Database he wants to connect to

CHOICES = c("SKF Vibration Kingsey Falls", "SKF Vibration Niagara Falls","SKF Microlog Inspector")
TITLE = "Select Database (enter zero to exit):"

dbname = switch(as.character(menu(CHOICES, title=TITLE)), 
                "1" = "skfuser.sql.cascades.com", 
                "2" = "db_skf_103.sql.norampac.com", 
                "3" = "skfuser2.sql.cascades.com")



## Connect to MSSQL Server holding requested data
cx <- odbcDriverConnect(paste("driver={SQL Server};",
                              "server=", dbname, ";",
                              "database=skfuser;",
                              "uid=skfuser1;",
                              "pwd=cm", sep=""))

## -- GET ROUTE HEADERS --
sqlcmd <- paste("select routeid, ",
                "year(skfuser1.to_date(enddts)) Annee, ",
                "month(skfuser1.TO_DATE(enddts)) Mois, ",
                "avg(duration) From routehistory ",
                "where routeid in (",
                "select routeid from routehistory ",
                "where startdts = '00010101000000') ",
                "and startdts<>'00010101000000' ", 
                "group by routeid, ",
                "year(skfuser1.to_date(enddts)), ",
                "month(skfuser1.TO_DATE(enddts))",
                sep="")
t_rtehdr <- sqlQuery(cx, sqlcmd)


