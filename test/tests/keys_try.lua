local Etcd = require('etcd.resty');

local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local key = '/test_key'
local val = {
    structured = {
        value = {
            of = 'key'
        }
    }
};
local consistent = true;
local res;

-- cleanup
ifNil( cli:delete( key ) )

res = ifNil( cli:get( key ) );
ifNotEqual( res.status, 404 );

res = ifNil( cli:setx( key, val ) );
ifNotEqual( res.status, 404 );

res = ifNil( cli:set( key, val ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:setnx( key, val ) );
ifNotEqual( res.status, 412 );

res = ifNil( cli:get( key ) );
ifNotEqual( inspect( val ), inspect( res.body.node.value ) );

res = ifNil( cli:get( key, consistent ) );
ifNotEqual( inspect( val ), inspect( res.body.node.value ) );

res = ifNil( cli:delete( key ) );
ifNotEqual( res.status, 200 );

