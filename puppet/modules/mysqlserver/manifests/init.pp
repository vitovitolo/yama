class mysqlserver
(
	$port = 3306,
	$bind_address="0.0.0.0",
	$server_maxmem = "2048",
	$root_pass = "root",
	$datadir = "/var/lib/mysql",
	$language = "en-US",
	$charset = "utf8",
	$motor = "innodb",
	$explicit_engine = true,
	$server_id = 1,
	$server_count = 1,
	$cluster_master = "mysql-master-ip",
	$template = "mysqlserver/my.cnf.erb",
)
{
	$mysql_user = "root"
	$mysql_pass = $root_pass
	$mysql_port = $port
	$mysql_bindaddress = $bind_address
	$mysql_datadir = $datadir
	$mysql_language = $language
	$mysql_charset = $charset
	$mysql_motor = $motor
	$mysql_explicit_engine = $explicit_engine
	$mysql_maxmem = $server_maxmem
	$mysql_master = $cluster_master
	$mysql_server_id = $server_id
	$mysql_server_count = $server_count
	#common
	package{["mysql-server-5.5", "mysql-client-5.5"]:
		ensure  =>"installed",
	}
	file {"/etc/mysql":
		ensure => "directory",
		require => Package["mysql-server-5.5"],

	}
	file {"/var/lib/mysql":
		ensure  => "directory",
		require => Package["mysql-server-5.5"],
	}

	file {"/etc/mysql/my.cnf":
		ensure  => "present",
		path    => "/etc/mysql/my.cnf",
		content => template($template),
		require => [Package["mysql-server-5.5"],File["/etc/mysql"],File["/var/lib/mysql"]],
	}
	#MYSQL ROOT PASSWORD
	exec{"mysqladmin":
		path    => ['/usr/bin', '/usr/sbin'],
		command => "mysqladmin -u${mysql_user} password \"${mysql_pass}\" && echo /dev/null > /root/.mysqladmin.passchanged",
		require => Package["mysql-server-5.5"],
		creates => "/root/.mysqladmin.passchanged",
	}
	service{"mysql":
		require    => Package["mysql-server-5.5"],
		ensure     => "running",
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		restart    => "/etc/init.d/mysql reload",
	}
	file {"mysql-clustermaster.sh":
		path    => "/root/mysql-clustermaster.sh",
		ensure  => "file",
		mode    => 0750,
		owner   => "root",
		group   => "root",
		content => template("mysqlserver/clustermaster.sh.erb"),
	}
	file {"mysql-clusterslave.sh":
		path    => "/root/mysql-clusterslave.sh",
		ensure  => "file",
		mode    => 0750,
		owner   => "root",
		group   => "root",
		content => template("mysqlserver/clusterslave.sh.erb"),
	}
	file {"mysql-createappuser.sh":
		path    => "/root/mysql-createappuser.sh",
		ensure  => "file",
		mode    => 0755,
		owner   => "root",
		group   => "root",
		content => template("mysqlserver/mysql-createappuser.sh.erb"),
	}
}
