local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local res, invalidIdx, validIdx;

-- cleanup
ifNil( cli:rmdir( '/path', true ) );

-- key
res = ifNil( cli:set( '/path/to/key', 'hello world' ) );
ifNotEqual( res.status, 201 );
invalidIdx = res.body.node.modifiedIndex;

-- update
res = ifNil( cli:setx( '/path/to/key', 'hello world', nil ) );
ifNotEqual( res.status, 200 );
validIdx = res.body.node.modifiedIndex;

-- compare and swap
res = ifNil( cli:setx( '/path/to/key', 'hello world', nil, invalidIdx ) );
ifNotEqual( res.status, 412 );

res = ifNil( cli:setx( '/path/to/key', 'hello world', nil, validIdx ) );
ifNotEqual( res.status, 200 );
validIdx = res.body.node.modifiedIndex;

-- compare and delete
res = ifNil( cli:delete( '/path/to/key', 'invalid value' ) );
ifNotEqual( res.status, 412 );
res = ifNil( cli:delete( '/path/to/key', nil, invalidIdx ) );
ifNotEqual( res.status, 412 );
res = ifNil( cli:delete( '/path/to/key', 'hello world', invalidIdx ) );
ifNotEqual( res.status, 412 );
res = ifNil( cli:delete( '/path/to/key', 'invalid value', validIdx ) );
ifNotEqual( res.status, 412 );

res = ifNil( cli:delete( '/path/to/key', 'hello world' ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:set( '/path/to/key', 'hello world' ) );
ifNotEqual( res.status, 201 );
res = ifNil( cli:delete( '/path/to/key', nil, res.body.node.modifiedIndex ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:set( '/path/to/key', 'hello world' ) );
ifNotEqual( res.status, 201 );
res = ifNil( cli:delete( '/path/to/key', 'hello world', res.body.node.modifiedIndex ) );
ifNotEqual( res.status, 200 );


-- cleanup
ifNil( cli:rmdir( '/path', true ) );
