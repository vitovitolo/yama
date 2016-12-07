class apt
(
)
{
	exec {"apt-get-update" :
		path     => ["/bin","/usr/bin"],
		command  => "apt-get update",
	}
}
