# === Class: concat::setup
# Sets up the concat system. This is a private class.
#
class concat::setup
{
	$concatdir="/root/.puppet-concat"
	$script_mode = '0755'
	$script_command = "$concatdir/bin/concatfragments.sh"
	file {"$concatdir":
		ensure => directory,
		mode   => 0755,
	}
	file {"$concatdir/bin":
		ensure  => directory,
		mode    => 0755,
		require => File["$concatdir"],
	}
	file {"$script_command":
		ensure  => file,
		mode    => 0755,
		require => File["$concatdir/bin"],
		backup  => false,
		content => template("concat/concatfragments.sh.erb"),
	}
}
