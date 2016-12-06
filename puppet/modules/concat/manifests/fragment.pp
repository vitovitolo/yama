# == Define: concat::fragment
# Puts a file fragment into a concat directory
#
# === Options:
# [*target*] The file that these fragment belong to
# [*content*] Content of the fragment
# [*source*] If content was not specified, use the source
# [*order*] prefix of the fragment file, to order them
# [*ensure*] Present/Absent
define concat::fragment(
	$target,
	$content = undef,
	$source  = undef,
	$order   = '10',
	$ensure  = "present"
) {
	include concat::setup
	if $ensure == undef {
		$my_ensure = getparam(Concat[$target], "ensure")
	} else {
		$my_ensure = $ensure
	}
	$safe_name        = regsubst($name, '[/:]', '_', 'G')
	$safe_target_name = regsubst($target, '[/:]', '_', 'G')
	$concatdir        = $concat::setup::concatdir
	$fragdir          = "${concatdir}/${safe_target_name}"
	case $my_ensure {
		"present":
			{
				if ($source and $content) {
					fail("You cannot specify both source and content")
				}
				file {"$fragdir/fragments/${order}_${safe_name}":
					ensure  => file,
					mode    => 0640,
					source  => $source,
					content => $content,
					backup  => false,
					alias   => "concat_fragment_$name",
					notify  => Exec["concat_$target"],
				}
			}
		"absent":
			{
				file {"$fragdir/fragments/${order}_${safe_name}":
					ensure  => absent,
					backup  => false,
					alias   => "concat_fragment_$name",
					notify  => Exec["concat_$target"],
				}
			}
		default:
			{
				fail("Invalid value ensure=$ensure")
			}
	}
}
