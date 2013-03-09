param($servername)

function InvokeSQL($databaseName, $sql, $commandDelegate) {
	Write-Host "Server=$servername;Integrated Security=True;Initial Catalog='$databaseName';pooling=false;"

	$connection = new-object data.sqlclient.sqlconnection "Server=$servername;Integrated Security=True;Initial Catalog='$databaseName';pooling=false;"
	$connection.Open()

	$command = $connection.CreateCommand()
	$command.CommandText = $sql

	& $commandDelegate $command
	
	$connection.Close()
	$connection.dispose()
}

function ExecuteNonQuerySQL($databaseName, $sql) {
	InvokeSQL $databaseName $sql { param($command) $command.ExecuteNonQuery() }
}