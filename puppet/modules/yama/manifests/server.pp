define yama::server
(
	$nodename = $name,
	$ip = "0.0.0.0",
	$port = "8080",
)
{
	include yama
	include supervisor

	supervisor::program{"${nodename}":
		program_path       => "/opt/yama",
		program_cmd        => "/opt/yama/yama-server",
		program_log_path => "/var/log/yama",
	}

	file {"/etc/yama/config_${nodename}.yaml":
		ensure => file,
		owner  => root,
		group  => root,
		require => [File["/etc/yama"],File["/opt/yama/yama"],File["/opt/yama/yama-server"]],
		notify  => Service["supervisor_${nodename}"],
		content => template("yama/config.yaml.erb"),
	}

}
