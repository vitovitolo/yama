define mysqlserver::grant (
	$user,
	$password,
	$db = "*",
	$privileges = "ALL",
	$root_pass = "root",
)
{
	include mysqlserver
	$grant_user = $user
	$grant_password = $password
	$grant_db = $db
	$grant_privileges = $privileges

	$mysql_grant_file = $db ? {
		"*"     => "/root/mysqlserver.grant.${user}.sql",
		default => "/root/mysqlserver.grant.${user}-${db}.sql",
	}
	file {"${mysql_grant_file}-${name}":
		ensure  => file,
		mode    => 0600,
		owner   => "root",
		group   => "root",
		content => template("mysqlserver/grant.erb"),
	}
	exec {"mysqlgrant-${user}-${db}-${name}":
		command   => "mysql -uroot -p$root_pass < ${mysql_grant_file}-${name}",
		path      => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"],
		subscribe => File["$mysql_grant_file-${name}"],
		require => Class["mysqlserver"],
	}
}
