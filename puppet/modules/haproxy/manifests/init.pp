class haproxy
(
)
{
	include apt

	package {"haproxy":
		ensure  => "installed",
		require => Exec["apt-get-update"],
	}
	package {"hatop":
		ensure  => "installed",
		require => Exec["apt-get-update"],
	}
	service {"haproxy":
		ensure     => "running",
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		require    => Package["haproxy"],
	}
	file {"/etc/haproxy/errors":
		ensure  => "directory",
		owner   => "root",
		group   => "root",
		mode    => 0755,
		require => Package["haproxy"],
	}
	# Customized http error pages
	customized_http_error_file { "400":
		error_msg         => "Bad request",
	}
	customized_http_error_file { "403":
		error_msg => "Forbidden",
	}
	customized_http_error_file { "408":
		error_msg => "Request Time-out",
	}
	customized_http_error_file { "500":
		error_msg => "Internal Error",
	}
	customized_http_error_file { "502":
		error_msg => "Bad Gateway",
	}
	customized_http_error_file { "503":
		error_msg => "Service Unavailable",
	}
	customized_http_error_file { "504":
		error_msg => "Gateway Time-out",
	}
	file {"/usr/sbin/reload_haproxy":
		ensure  => "file",
		owner   => "root",
		group   => "root",
		mode    => 0750,
		require => Package["haproxy"],
		content => template("haproxy/reload_haproxy.erb"),
	}
}

define customized_http_error_file
(
	$http_error = $name,
	$error_msg = "",
)
{
	file {"/etc/haproxy/errors/${http_error}error.http":
		ensure  => "file",
		owner   => "root",
		group   => "root",
		mode    => 0644,
		require => File["/etc/haproxy/errors"],
		content => template("haproxy/custom_error.erb"),
	}
}
