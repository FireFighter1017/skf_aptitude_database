library(RODBC)
library(dplyr)
library(readr)


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

## -- GET POINTS FROM ROUTE -- 
sqlcmd <- read_file("ROUTE_POINTS.sql")
t_rtepts <- sqlQuery(cx, sqlcmd)

## Build Route Structure
output <- inner_join(t_rtehdr, t_rtepts)

## -- GET POINTS FREQUENCIES -- 
sqlcmd <- read_file("POINT_FREQUENCIES.sql")
t_freq <- sqlQuery(cx, sqlcmd)

###   Rename POINT as a REFERENCe POINT
colnames(t_freq)[4] = "REF_POINT"

## Link frequencies to route points
output = inner_join(output, t_freq)

write.csv2(output, "output.csv", row.names=FALSE)

## -- GET TREE --
sqlcmd <- read_file("TREE_STRUCTURE.sql")
t_struct <- sqlQuery(cx, sqlcmd)