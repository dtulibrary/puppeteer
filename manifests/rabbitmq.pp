node default {
  class {'metastore::rabbitmq':
    username => 'rabbit',
    password => 'rabbit',
  }
}
