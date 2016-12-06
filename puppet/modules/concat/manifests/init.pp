# == Define: concat
# Sets up so that you can use fragments to build a final config file,
#
# === Options:
# [*ensure*] Present/Absent
# [*path*] The path to the final file.
# [*owner*] Who will own the file
# [*group*] Who will own the file
# [*mode*] The mode of the final file
# [*allow_empty*] Enables creating empty files if no fragments are present
# [*replace*] Whether to replace a file that already exists on the local system
# [*ensure_newline*] Forcely adds a newline between fragments
#
# === Actions:
# * Creates fragment directories if it didn't exist already
# * Executes the concatfragments.sh script to build the final file, this
#   script will create directory/fragments.concat.   Execution happens only
#   when:
#   * The directory changes
#   * fragments.concat != final destination, this means rebuilds will happen
#     whenever someone changes or deletes the final file.  Checking is done
#     using /usr/bin/cmp.
#   * The Exec gets notified by something else - like the concat::fragment
#     define
# * Copies the file over to the final destination using a file resource
#
# === Aliases:
#
# * The exec can notified using Exec["concat_$name"]
# * The final file can be referenced as File["/path/to/file"]
#
define concat(
	$ensure = 'present',
	$path = $name,
	$owner = undef,
	$group = undef,
	$mode = '0644',
	$allow_empty = false,
	$replace = true,
	$ensure_newline = false,
	$backup = 'puppet',
)
{
	include concat::setup
	$safe_name = regsubst($name, '[/:]', '_', 'G')
	$concatdir = $concat::setup::concatdir
	$fragdir = "${concatdir}/${safe_name}"
	$concat_name = 'fragments.concat.out'
	$script_command = $concat::setup::script_command

	$forceflag = $allow_empty ? {
		true  => '-f',
		default => '',
	}
	$newlineflag = $ensure_newline ? {
		true  => '-l',
		default => '',
	}
	case $ensure {
		"present":
			{
				file {"$fragdir":
					ensure  => directory,
					mode    => 0750,
					require => File["$concatdir"],
				}
				file {"$fragdir/fragments":
					ensure  => directory,
					mode    => 0750,
					force   => true,
					ignore  => [".svn",".git",".gitignore"],
					require => File["$fragdir"],
					notify  => Exec["concat_${name}"],
					purge   => true,
					recurse => true,
				}
				file {"$fragdir/fragments.concat":
					ensure => present,
					mode   => 0640,
				}
				file {"$fragdir/$concat_name":
					ensure => present,
					mode   => 0640,
				}
				file { "$name":
					ensure  => present,
					owner   => $owner,
					group   => $group,
					mode    => $mode,
					replace => $replace,
					path    => $path,
					source  => "$fragdir/$concat_name",
					backup  => $backup,
				}
				$command = "${script_command} -o \"${fragdir}/${concat_name}\" -d \"${fragdir}\" ${forceflag} ${newlineflag}"
				exec { "concat_${name}":
					command   => $command,
					notify    => File[$name],
					subscribe => File[$fragdir],
					unless    => "${command} -t",
					require   => [
						File["$fragdir"],
						File["${fragdir}/fragments"],
						File["${fragdir}/fragments.concat"],
					],
				}
			}
		"absent":
			{
				file {
					[
						"$fragdir",
						"$fragdir/fragments",
						"$fragdir/fragments.concat",
						"$fragdir/$concat_name",
					]:
					ensure => absent,
					backup => $backup,
				}
				file { "$name":
					path    => $path,
					ensure  => absent,
					backup  => $backup,
				}
				exec { "concat_${name}":
					command => "/bin/true",
					require   => [
						File["$fragdir"],
						File["${fragdir}/fragments"],
						File["${fragdir}/fragments.concat"],
					],
				}
			}
		default:
			{	
				fail("Invalid value ensure=$ensure")
			}
	}
}
