node default {

  include apt
  apt::ppa{ 'ppa:brightbox/ruby-ng': }
  
  ensure_packages(['ruby2.1-dev', 'bundler', 'postgresql-server-dev-9.3', 'libsqlite3-dev'])

  class { 'postgresql::server': } 
  class { 'postgresql::server::postgis': } 

  postgresql::server::role { 'vagrant':
    superuser      => true,
    password_hash  => postgresql_password('vagrant','vagrant'),
  }

  postgresql::server::pg_hba_rule { 'allow to access db':
    description => 'allow to access db',
    order       => '001',
    type        => 'local',
    database    => 'all',
    user        => 'vagrant',
    auth_method => 'ident',
  }

  exec { 'bundle setup':
    command => '/usr/bin/bundle install --path=/tmp/cruiselog',
    unless  => '/usr/bin/bundle check',
    cwd     => '/vagrant',
    user    => 'vagrant',
    require => Package['ruby2.1-dev']
  }

}
