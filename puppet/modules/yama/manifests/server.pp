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
		program_log_stderr => "/var/log/yama/error.log",
		program_log_stdout => "/var/log/yama/access.log",
	}

	file {"/etc/yama/config_${nodename}.yaml":
		ensure => file,
		owner  => root,
		group  => root,
		require => [File["/etc/yama"],File["/etc/yama/yama"],File["/etc/yama/yama-server"]],
		notify  => Service["supervisor_${programname}"],
		content => template("yama/config.yaml.erb"),
	}

}
