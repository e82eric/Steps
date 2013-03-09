function CreateADUser($name) {
	$domain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://CN=Users,DC=$script:computerName,DC=net")
	$user = $domain.Children.Add("CN=$name", "user")
	$user.Properties["samAccountName"].Value = $name
	$user.CommitChanges() | Out-Null

	$user.Invoke("SetPassword", "$script:password") | Out-Null
	$user.CommitChanges() | Out-Null

	$uac = $user.Properties["userAccountControl"].Value
	$user.Properties["userAccountControl"].Value = $uac -bor 0x10000

	$user.CommitChanges() | Out-Null

	$uac = $user.Properties["userAccountControl"].Value
	$user.Properties["userAccountControl"].Value = ($uac -bor 0x200) -band -bnot 0x2

	$user.CommitChanges() | Out-Null

	$psUser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$script:netBiosName\$name",$script:secureStringPassword

	$psUser
}