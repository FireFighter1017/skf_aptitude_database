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
sqlcmd <- read_file("RTEHDR.sql")
t_rtehdr <- sqlQuery(cx, sqlcmd)

## -- GET POINTS FROM HIERARCHY --
sqlcmd <- read_file("HIERARCHY_POINTS.sql")
t_elem <- sqlQuery(cx, sqlcmd)

## -- GET POINTS FROM ROUTE -- 
sqlcmd <- read_file("ROUTE_POINTS.sql")
t_rtepts <- sqlQuery(cx, sqlcmd)

## -- GET ROUTE HISTORY --
sqlcmd <- read_file("ROUTEHISTORY.sql")
t_rtehst <- sqlQuery(cx, sqlcmd)

## -- GROUP HISTORY BY ROUTE --
by_id = aggregate(t_rtehst, list(t_rtehst$ROUTEID), sum)


t_routes <- inner_join(t_rtehdr, t_elem[t_elem$CONTAINERTYPE == CT_ROUTE], by.x="ELEMENTID", by.y="TREEELEMID")

image = sqlQuery(cx, "select readingheader from measreading where pointid=10013 and readingid=1236309", rows_at_time = 1)
load.image(image)

## Filter on Backup Extinguishers routes
rte_res <- tbl_df(t_routes$NAME[grepl("0004$", t_routes$NAME)])

sqlcmd <- "select * From RTEHISTORY"
t_rtehdr <- sqlQuery(cx, sqlcmd)