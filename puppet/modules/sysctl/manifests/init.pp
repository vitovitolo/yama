class sysctl {
	exec {"sysctl-reload":
		command     => "/sbin/sysctl --system",
		refreshonly => true,
		path        => [ "/bin", "/usr/bin", "/sbin", "/usr/sbin" ],
	}
}
