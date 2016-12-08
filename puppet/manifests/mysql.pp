node "default" {
	class {"mysqlserver":
		server_maxmem => "1024",
		root_pass => "root",
	}
}
