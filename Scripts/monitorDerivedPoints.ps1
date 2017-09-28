$SQLServer = "skfuser.sql.cascades.com"
$SQLDBName = "skfuser"
$uid = "skfuser1"
$pwd = "cm"
$file = ".\report.csv"

$SqlQuery = "Select count(*) from (select name, skfuser1.TO_DATE(max(datadtg)) last_measurement from measurement, treeelem where pointid = treeelemid and name like '%BANDE COATING' group by name) lastRecords where datediff(minute, getdate(), last_measurement) > 5;"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = False; User ID = $uid; Password = $pwd;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$rowCount = $Dataset.Tables[0].Rows[0][0]

if ($rowCount > 0) {
    $DataSet.Tables[0] | out-file "$file"
    $mailboxdata | export-csv "$file"
    $smtpServer = "smtp.cascades.com"
    $att = new-object Net.Mail.Attachment($file)
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $msg.From = "skf_monitor_alert@cascades.com"
    $msg.To.Add("pascal_bellerose@cascades.com")
    $msg.Subject = "OnlineTissus-MonitorError"
    $msg.Body = "$rowCount Voir le rapport attaché."
    $msg.Attachments.Add($att)
    $smtp.Send($msg)
    $att.Dispose()
} else {
    $smtpServer = "smtp.cascades.com"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $msg.From = "skf_monitor_alert@cascades.com"
    $msg.To.Add("pascal_bellerose@cascades.com")
    $msg.Subject = "OnlineTissu-Ok"
    $msg.Body = "RowCount: $rowCount"
    $smtp.Send($msg)
} 

