node default {

  ensure_packages(['ruby2.3-dev', 'bundler', 'postgresql-server-dev-9.5', 'libsqlite3-dev'])

  class { 'postgresql::server': } 
  class { 'postgresql::server::postgis': } 

  postgresql::server::role { 'ubuntu':
    superuser      => true,
    password_hash  => postgresql_password('ubuntu','ubuntu'),
  }

  postgresql::server::pg_hba_rule { 'allow to access db':
    description => 'allow to access db',
    order       => '001',
    type        => 'local',
    database    => 'all',
    user        => 'ubuntu',
    auth_method => 'ident',
  }

  exec { 'bundle setup':
    command => '/usr/bin/bundle install --path=/tmp/cruiselog',
    unless  => '/usr/bin/bundle check',
    cwd     => '/vagrant',
    user    => 'ubuntu',
    require => Package['ruby2.3-dev']
  }

}
