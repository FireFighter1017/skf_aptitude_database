library(RODBC)

##===========
## Constants
##-----------
# Container types
CT_ROUTE = 1                 ## Route Header

## Route type
RT_BKP = "0004$"             ## Backup Fire Ext.

## Ask user which Database he wants to connect to
opt = -1
while(opt < 0&interactive()){
  opt = readline(prompt=paste("\n\n\nSelect Database: \n\n",
                                 "   1 - SKF Vibration Kingsey Falls \n",
                                 "   2 - SKF Vibration Niagara Falls \n",
                                 "   3 - SKF Microlog Inspector \n\n",
                                 "Enter a selection: ", sep=""))
  opt = ifelse(grepl("\\D",opt), -1, as.integer(opt))
  if(is.na(opt)){break}
}
CHOICES = c("SKF Vibration Kingsey Falls", "SKF Vibration Niagara Falls","SKF Microlog Inspector")
TITLE = "Select Database (enter zero to exit):"
print("\n\n")
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

sqlcmd <- "select * From ROUTEHDR join treeelem on treeelemid=elementid"
t_rtehdr <- sqlQuery(cx, sqlcmd)

sqlcmd <- "Select * From treeelem"
t_elem <- sqlQuery(cx, sqlcmd)

t_routes <- inner_join(t_rtehdr, t_elem[t_elem$CONTAINERTYPE == CT_ROUTE], by.x="ELEMENTID", by.y="TREEELEMID")


## Filter on Backup Extinguishers routes
rte_res <- tbl_df(t_routes$NAME[grepl("0004$", t_routes$NAME)])

sqlcmd <- "select * From RTEHISTORY"
t_rtehdr <- sqlQuery(cx, sqlcmd)