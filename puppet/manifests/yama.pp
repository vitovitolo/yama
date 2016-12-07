node "default" {

	yama::server {"node1":
		ip 	=> "0.0.0.0",
		port   => "80",
	}
}
