define sysctl::conf
(
	$filename = "$name",
	$content = ""
)
{
	file {"/etc/sysctl.d/$filename.conf":
		ensure  => file,
		owner   => "root",
		group   => "root",
		mode    => 0640,
		content => $content,
		notify  => Exec["sysctl-reload"],
	}
}
