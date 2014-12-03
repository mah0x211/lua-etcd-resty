local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local key = '/path/to/dir'
local val = {
    structured = {
        value = {
            of = 'key'
        }
    }
};
local res;

-- cleanup
ifNil( cli:rmdir( '/path', true ) );

res = ifNil( cli:set( key, val ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:push( key, val ) );
ifNotEqual( res.status, 400 );

res = ifNil( cli:rmdir( '/path', true ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:mkdir( key ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:push( key, val ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:push( key, val ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:readdir( key ) );
ifNotEqual( res.status, 200 );
ifNotEqual( #res.body.node.nodes, 2 );

-- cleanup
ifNil( cli:rmdir( '/path', true ) );
