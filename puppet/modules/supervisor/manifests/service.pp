define supervisor::service (
	$content = "",
	$allowrestart = true,
)
{
	file {"/etc/supervisor/conf.d/$svcname.conf":
		ensure  => file,
		require => Package["supervisor"],
		notify  => Service["supervisor"],
		content => $content,
	}

	if $allowrestart {
		$restart = "/usr/bin/supervisorctl restart $svcname"
	} else {
		$restart = "/bin/echo I will NOT restart $svcname sub-service. Please do it manually."
	}
	service {"supervisor_$svcname":
		ensure     => "running",
		hasrestart => true,
		hasstatus  => true,
		restart    => $restart,
		start    => "/usr/bin/supervisorctl start $svcname",
		stop    => "/usr/bin/supervisorctl stop $svcname",
		status    => "/usr/bin/supervisorctl status $svcname | grep -i running",
	}
}
