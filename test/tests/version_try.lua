local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local res = ifNil( cli:version() );

ifNotEqual( res.status, 200 );
