node default {
  class {'debian_host':}

  class {'toshokan':
    rails_env  => 'staging',
    conf_set   => 'staging',
    vhost_name => 'unstable.toshokan.docker.io',
  }
}
