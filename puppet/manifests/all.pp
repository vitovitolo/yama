node "default" {
	# Set variables for all modules
	$shard_db_hostname = "localhost"
	$shard_db_name = "yama"
	$shard_db_username = "yama"
	$shard_db_passwd = "yama"

	$main_db_name = "yama"
	$main_db_username = "yama"
	$main_db_passwd = "yama"

	$cache_max_urls = "5000"
	$cache_url_ttl = "100"

	# Install yama servers
	yama::server {"node1":
		ip 	=> "localhost",
		port    => "8080",
		shard_db_name => $shard_db_name,
		main_db_name => $main_db_name,
		cache_max_urls => $cache_max_urls,
		cache_url_ttl => $cache_url_ttl,
		require => [Mysqlserver::Applysql['shards'],Mysqlserver::Applysql['urls'],Class['redis']],
	}
	yama::server {"node2":
		ip 	=> "localhost",
		port   => "8081",
		shard_db_name => $shard_db_name,
		main_db_name => $main_db_name,
		cache_max_urls => $cache_max_urls,
		cache_url_ttl => $cache_url_ttl,
		require => [Mysqlserver::Applysql['shards'],Mysqlserver::Applysql['urls'],Class['redis']],
	}
	# Install and config haproxy_external with 2 yama servers
	haproxy::haproxy {"external":
		ip 	  	         => "0.0.0.0",
		backends      	 => [ 
			{
				"name"      => "node1",
				"hostname"  => "localhost",
				"port"      => "8080",
			},
			{ 
				"name"      => "node2",
				"hostname"  => "localhost",
				"port"      => "8081",
			}
		]
	}
	class {"mysqlserver":
		server_maxmem => "1024",
		root_pass => "root",
	}
	mysqlserver::applysql {"shards":
		sql_content => template("yama/mysql_shards.sql.erb"),
		db_name     => $shard_db_name,
	}
	mysqlserver::applysql {"urls":
		sql_content => template("yama/mysql_urls.sql.erb"),
		db_name     => $main_db_name,
	}
	mysqlserver::grant {"yama_shards":
		user      => $shard_db_username,
		password  => $shard_db_passwd,
		db        => $shard_db_name,
		root_pass => "root",
	}
	mysqlserver::grant {"yama_urls":
		user      => $main_db_username,
		password  => $main_db_passwd,
		db        => $main_db_name,
		root_pass => "root",
	}
	class {"redis":	}
}
