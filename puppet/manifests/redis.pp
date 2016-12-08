node "default" {
	class {"redis":
		bind_address => "0.0.0.0",
		bind_port => "6379",
	}
}
