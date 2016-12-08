class redis
(
	$bind_address="0.0.0.0",
	$bind_port="6379",
	$ulimit = "",
)
{
	include sysctl

	$redis_bind_address=$bind_address
	$redis_bind_port=$bind_port
	package {"redis-server":
		ensure  => "installed",
		require => Exec["apt-get-update"],
	}
	file {"/etc/redis/redis.conf":
		ensure  => "file",
		content => template("redis/redis.conf.erb"),
		require => Package["redis-server"],
		notify  => Service["redis-server"],
	}
	service {"redis-server":
		ensure  => "running",
		require => Package["redis-server"],
	}

	if $ulimit {
		file {"/etc/default/redis-server":
			owner => root,
			group => root,
			content => "ULIMIT=$ulimit
",
			notify => Service['redis-server'],
			require => Package["redis-server"]
		}
	}

	sysctl::conf{"vm-overcommit-memory":
		content => "vm.overcommit_memory=1"
	}
}
