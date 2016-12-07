node "default" {
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
