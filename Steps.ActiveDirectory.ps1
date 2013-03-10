param($fqdn, $password)

$_fqdn = $fqdn
$_password = $password

function CreateADUser($name) {
	$domain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$_fqdn")
	$users = $domain.Children | ? { $_.cn -eq "users" }
	$user = $users.Children.Add("CN=$name", "user")
	$user.Properties["samAccountName"].Value = $name
	$user.CommitChanges() | Out-Null

	$user.Invoke("SetPassword", "$_password") | Out-Null
	$user.CommitChanges() | Out-Null

	$uac = $user.Properties["userAccountControl"].Value
	$user.Properties["userAccountControl"].Value = $uac -bor 0x10000

	$user.CommitChanges() | Out-Null

	$uac = $user.Properties["userAccountControl"].Value
	$user.Properties["userAccountControl"].Value = ($uac -bor 0x200) -band -bnot 0x2

	$user.CommitChanges() | Out-Null

	$secureStringPassword = ConvertTo-SecureString "$_password" -AsPlainText -Force
	$psUser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$_fqdn\$name",$secureStringPassword

	$psUser
}