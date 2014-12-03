local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local res;

res = ifNil( cli:statsLeader() );
ifNotEqual( res.status, 200 );

res = ifNil( cli:statsSelf() );
ifNotEqual( res.status, 200 );

res = ifNil( cli:statsStore() );
ifNotEqual( res.status, 200 );
