local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local ttl = 1;
local res;

-- cleanup
ifNil( cli:rmdir( '/path', true ) );

-- dir
res = ifNil( cli:mkdir( '/path/to/dir' ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:set( '/path/to/dir/key', 'hello world' ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:setTTL( '/path', ttl ) );
ifNotEqual( res.status, 200 );
res = ifNil( cli:get( '/path/to/dir/key' ) );
ifNotEqual( res.status, 200 );

sleep( ttl + 1 );
res = ifNil( cli:readdir( '/path', true ) );
ifNotEqual( res.status, 404 );

res = ifNil( cli:mkdir( '/path', ttl ) );
ifNotEqual( res.status, 201 );
sleep( ttl + 1 );
res = ifNil( cli:readdir( '/path', true ) );
ifNotEqual( res.status, 404 );


-- key
res = ifNil( cli:set( '/path/to/key', 'hello world' ) );
ifNotEqual( res.status, 201 );
res = ifNil( cli:setTTL( '/path/to/key', ttl ) );
ifNotEqual( res.status, 200 );
sleep( ttl + 1 );
res = ifNil( cli:get( '/path/to/key' ) );
ifNotEqual( res.status, 404 );

res = ifNil( cli:set( '/path/to/key', 'hello world', ttl ) );
ifNotEqual( res.status, 201 );
sleep( ttl + 1 );
res = ifNil( cli:get( '/path/to/key' ) );
ifNotEqual( res.status, 404 );


-- queue
res = ifNil( cli:mkdir( '/path/to/dir' ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:push( '/path/to/dir', 'q1' ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:push( '/path/to/dir', 'q2', ttl ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:readdir( '/path/to/dir' ) );
ifNotEqual( res.status, 200 );
ifNotEqual( #res.body.node.nodes, 2 );

sleep( ttl + 1 );
res = ifNil( cli:readdir( '/path/to/dir' ) );
ifNotEqual( res.status, 200 );
ifNotEqual( #res.body.node.nodes, 1 );

-- cleanup
ifNil( cli:rmdir( '/path', true ) );
