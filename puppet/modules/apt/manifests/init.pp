class apt
(
)
{
	exec {"apt-get-update" :
		path     => ["/bin","/usr/bin"],
		command  => "apt-get update",
		schedule => "only-once-a-day",
	}
	schedule {"only-once-a-day":
		period => daily,
	}
}
