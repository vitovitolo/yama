class yama
(
)
{
	include supervisor

	package { [ "python-bottle","python-mysqldb", "python-yaml" ]:
		ensure  => "installed",
		require => Exec["apt-get-update"],
	}
	
	file {"/opt/yama":
		ensure  => directory,
		owner   => "root",
		group   => "root",
		mode    => 755,
	}
	file {"/opt/yama/yama":
		ensure  => directory,
		owner   => "root",
		group   => "root",
		source  => 'puppet:///modules/yama/install_files',
		links   => "follow",
		recurse => true,
		require => File["/opt/yama"],
	}
	file {"/opt/yama/yama-server":
		ensure  => file,
		owner   => "root",
		group   => "root",
		mode    => 755,
		source => 'puppet:///modules/yama/yama-server',
		links   => "follow",
		require => File["/opt/yama/yama"],
	}
	file {"/var/log/yama":
		ensure => directory,
		owner  => "root",
		group  => "root",
		mode   => 755,
	}
	file {"/etc/yama":
		ensure => directory,
		owner  => "root",
		group  => "root",
		mode   => 755,
	}

}
