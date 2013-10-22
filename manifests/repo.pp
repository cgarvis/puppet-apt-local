# Sets up a local apt repository, ready for using with apt::localpackage
class apt_local::repo($repodir = '/var/cache/local-repo') {
  file { $repodir:
    ensure  => directory,
    mode    => '0755',
    notify  => Exec[apt-update-local-repo]
  }
  exec { 'apt-update-local-repo':
    cwd         => $repodir,
    command     => '/usr/bin/apt-ftparchive packages . > Packages',
    require     => [File[$repodir]],
    before      => Exec['apt-update'],
    notify      => Exec['apt-update'],
    refreshonly => true
  }
  apt::source { 'apt-local-repo':
    source => "deb [trusted=yes] file:${repodir} /",
  }
}

