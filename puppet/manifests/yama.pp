node /.*/ {

	yama::instance{"node1":
		ip 	=> "0.0.0.0",
		port   => "8080",
	}

	yama::instance{"node2":
		ip 	=> "0.0.0.0",
		port   => "8081",
	}
}
