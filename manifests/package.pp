# Defines a deb package to download and put into the local apt repository.
# Requires that you set a url
define apt_local::package($url = '', $repodir = '/var/cache/local-repo') {
  $url_tokens = split($url, '/')
  $pkg_filename = $url_tokens[-1]
  exec { "apt-localpackage-${name}":
    command => "/usr/bin/curl -L -s -C - -O ${url}",
    cwd     => $repodir,
    creates => "${repodir}/${pkg_filename}",
    notify  => Exec['apt-update-local-repo'],
    require => File[$repodir]
  }
}
