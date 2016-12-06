class supervisor 
(
	$ensure = "running",
	$enable = true,
)
{
	package {"supervisor":
		ensure  => "installed",
		require => Exec["apt-get-update"],
	}
	file {"/etc/init.d/supervisor":
		ensure  => file,
		owner   => root,
		group   => root,
		mode    => 0755,
		content => template("supervisor/supervisor-init.erb"),
		require => Package["supervisor"],
	}
	exec {"ensure-supervisor-order":
		path    => ["/usr/local/sbin","/usr/local/bin", "/usr/sbin","/usr/bin", "/sbin","/bin"],
		command => "insserv -d && touch /root/.supervisor-order-ensured",
		creates => "/root/.supervisor-order-ensured",
		require => File["/etc/init.d/supervisor"],
	}
	service {"supervisor":
		ensure     => $ensure,
		enable     => $enable,
		hasstatus  => true,
		require    => Exec["ensure-supervisor-order"],
		restart   => "/etc/init.d/supervisor restart",
	}
}
