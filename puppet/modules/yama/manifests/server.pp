define yama::server
(
	$nodename = $name,
	$ip = "0.0.0.0",
	$port = "8080",
	$write_db_hostname = "localhost",
	$main_db_username = "yama",
	$main_db_passwd = "yama",
	$main_db_name = "yama",
	$shard_db_hostname = "localhost",
	$shard_db_username = "yama",
	$shard_db_passwd = "yama",
	$shard_db_name = "yama",
	$cache_max_urls = "5000",
	$cache_url_ttl = "100",
)
{
	include yama
	include supervisor

	file {"/etc/yama/config_${nodename}.yaml":
		ensure => file,
		owner  => root,
		group  => root,
		require => [File["/etc/yama"],File["/opt/yama/yama"],File["/opt/yama/yama-server"]],
		notify  => Service["supervisor_${nodename}"],
		content => template("yama/config.yaml.erb"),
	}

	supervisor::program{"${nodename}":
		program_path     => "/opt/yama",
		program_cmd      => "/opt/yama/yama-server -c /etc/yama/config_${nodename}.yaml",
		program_log_path => "/var/log/yama",
		require          => File["/etc/yama/config_${nodename}.yaml"],
	}


}
