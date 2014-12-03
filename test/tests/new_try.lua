local Etcd = require('etcd.resty');

-- opt must has gateway:string field
ifNotNil( Etcd.new( '' ) );
ifNotNil( Etcd.new({}) );
ifNotNil( Etcd.new() );
ifNotNil( Etcd.new({
    gateway = 1
}) );
ifNil( Etcd.new({
    gateway = '/proxy_gateway'
}) );

-- timeout must be uint
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    timeout = ''
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    timeout = 10
}));

-- host must be string
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    host = 0
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    host = '127.0.0.1'
}));

-- clientPort must be uint
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    clientPort = ''
}));
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    clientPort = -1
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    clientPort = 8000
}));

-- adminPort must be uint
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    adminPort = ''
}));
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    adminPort = -1
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    adminPort = 8000
}));

-- https must be boolean
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    https = ''
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    https = false
}));

-- prefix must be string
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    prefix = 0
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    prefix = '/app/cache'
}));

-- ttl must be int
ifNotNil( Etcd.new({
    gateway = '/proxy_gateway',
    ttl = true
}));
ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    ttl = 60
}));

