define supervisor::program (
	$programname = $name,
	$program_path = "/tmp",
	$program_cmd = "/bin/true",
	$program_log_path = "/var/log/${name}",
)
{
	include supervisor

	$program_log_stderr = "${program_log_path}/${programname}_error.log"
	$program_log_stdout = "${program_log_path}/${programname}.log"

	service {"supervisor_$programname":
		ensure    => "running",
		hasrestart => true,
		hasstatus  => true,
		start      => "/usr/bin/supervisorctl start $programname",
		stop       => "/usr/bin/supervisorctl stop $programname",
		status     => "/usr/bin/supervisorctl status $programname | grep -i running",
		require    => [File["$program_path"],File["$program_log_path"],File["/etc/supervisor/conf.d/$programname.conf"]],
	}

	file {"/etc/supervisor/conf.d/$programname.conf":
		ensure  => file,
		require => [Service["supervisor"],File["${program_path}"],File["${program_log_path}"]],
		notify  => Service["supervisor_${programname}"],
		content => template("supervisor/supervisor_program.conf.erb"),
	}
}
