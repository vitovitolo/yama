node "default" {

	yama::server {"node1":
		ip 	=> "0.0.0.0",
		port   => "8080",
	}

	yama::server {"node2":
		ip 	=> "0.0.0.0",
		port   => "8081",
	}
}
