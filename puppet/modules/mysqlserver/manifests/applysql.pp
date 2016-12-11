define mysqlserver::applysql 
(
	$sql_content = "SELECT 1;",
	$db_name = "mysql",
	$db_user = "root",
	$db_pass = "root",

)
{
	file {"/tmp/.sql_${name}":
		ensure  => file,
		owner   => "root",
		group   => "root",
		content => $sql_content,
	}
	exec {"apply_schema_${name}":
		path     => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:/usr/sbin:/usr/local/sbin",
		command  => "mysql -u${db_user} -p${db_pass} < /tmp/.sql_${name} && touch /root/.apply_schema_${name}",
		requires => "/tmp/.sql_${name}",
		creates  => "/root/.apply_schema_${name}",
	}
}
