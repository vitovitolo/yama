node "default" {
	# Install yama servers
	yama::server {"node1":
		ip 	=> "localhost",
		port   => "8080",
	}
	yama::server {"node2":
		ip 	=> "localhost",
		port   => "8081",
	}
	# Install and config haproxy_external with 2 yama servers
	haproxy::haproxy {"external":
		ip 	  	         => "0.0.0.0",
		backends      	 => [ 
			{
				"name"      => "node1",
				"hostname"  => "localhost",
				"port"      => "8080",
			},
			{ 
				"name"      => "node2",
				"hostname"  => "localhost",
				"port"      => "8081",
			}
		]
	}
}
