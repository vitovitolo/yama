class yama
(
)
{
	include supervisor

	package { [ "python-bottle","python-mysqldb", "python-yaml" ]:
	}
	
	file {"/opt/yama":
		ensure  => directory,
		owner   => root,
		group   => root,
		mode    => 755,
	}
	file {"/opt/yama/yama":
		ensure  => directory,
		owner   => root,
		group   => root,
		mode    => 755,
		source  => 'puppet:///modules/yama/install_files',
		recurse => true,
	}
	file {"/opt/yama/yama-server":
		ensure  => file,
		owner   => root,
		group   => root,
		mode    => 755,
		content  => 'puppet:///modules/yama/yama-server',
	}
	file {"/var/log/yama":
		ensure => directory,
		owner  => root,
		group  => root,
		mode   => 755,
	}
	file {"/etc/yama":
		ensure => directory,
		owner  => root,
		group  => root,
		mode   => 755,
	}

}
