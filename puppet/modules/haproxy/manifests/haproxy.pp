define haproxy::haproxy 
(
	$haproxy_name = "$name",
	$ip = "127.0.0.1",
	$required_start = "",
	$config_template = "haproxy.erb",
	$backends = [],
)
{
	include haproxy
	$haproxy_required_start=$required_start
	file {"/etc/init.d/haproxy_$haproxy_name":
		ensure  => file,
		owner   => root,
		group   => root,
		mode    => 0750,
		require => Package["haproxy"],
		content => template("haproxy/haproxy_init.erb"),
	}
	file {"/etc/haproxy/haproxy_$haproxy_name.cfg":
		ensure  => file,
		owner   => root,
		group   => root,
		mode    => 0644,
		content => template("haproxy/${config_template}"),
		require => Package["haproxy"],
		notify  => Service["haproxy_$haproxy_name"],
	}
	exec {"install-haproxy-$haproxy_name":
		command => "update-rc.d haproxy_$haproxy_name defaults",
		path    => ["/bin","/sbin","/usr/bin","/usr/sbin","/usr/local/bin"],
		unless  => "ls /etc/rc2.d/S??haproxy_$haproxy_name",
		require => File["/etc/init.d/haproxy_$haproxy_name"],
		before  => Service["haproxy_$haproxy_name"],
	}
	service {"haproxy_$haproxy_name":
		ensure     => running,
		hasstatus  => true,
		hasrestart => true,
		restart    => "/etc/init.d/haproxy_$haproxy_name reload",
		require    => File["/etc/init.d/haproxy_$haproxy_name"],
	}
	file {"/etc/default/haproxy_$haproxy_name":
		ensure  => file,
		owner   => root,
		group   => root,
		mode    => 0644,
		content => template("haproxy/default.erb"),
		before  => Service["haproxy_$haproxy_name"],
		notify  => Service["haproxy_$haproxy_name"],
	}
}
