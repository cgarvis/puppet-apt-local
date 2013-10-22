# Sets up a local apt repository, ready for using with apt::localpackage
class apt_local::repo($repodir = "/var/cache/local-repo") {
  file { "${repodir}":
    ensure => directory,
    mode => 755,
    notify => Exec[apt-update-local-repo]
  }
  exec { "apt-update-local-repo":
    cwd => $repodir,
    command => "/usr/bin/apt-ftparchive packages . > Packages",
    require => [File["${repodir}"]],
    before => Exec["apt-update"],
    notify => Exec["apt-update"],
    refreshonly => true
  }
  apt::source { "apt-local-repo":
    source => "deb [trusted=yes] file:${repodir} /",
  }
}

# Defines a deb package to download and put into the local apt repository.
# Requires that you set a url
define apt_local::package($url = "", $repodir = "/var/cache/local-repo") {
  $url_tokens = split($url, '/')
  $pkg_filename = $url_tokens[-1]
  exec { "apt-localpackage-${name}":
    command => "/usr/bin/curl -L -s -C - -O $url",
    cwd => $repodir,
    creates => "${repodir}/${pkg_filename}",
    notify => Exec["apt-update-local-repo"],
    require => File[$repodir]
  }
}
