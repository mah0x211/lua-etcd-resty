local Etcd = require('etcd.resty');

local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local recursive = true;
local consistent = true;
local res;

-- cleanup
ifNil( cli:rmdir( '/path', recursive ) );

res = ifNil( cli:mkdir( '/path/to/dir' ) );
ifNotEqual( res.status, 201 );

res = ifNil( cli:readdir( '/', recursive ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:readdir( '/', recursive, consistent ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:rmdir( '/path', recursive ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:readdir( '/path/to/dir' ) );
ifNotEqual( res.status, 404 );

-- mkdir if not exists
res = ifNil( cli:mkdirnx( '/path/to/dir' ) );
ifNotEqual( res.status, 201 );
res = ifNil( cli:mkdirnx( '/path/to/dir' ) );
ifNotEqual( res.status, 412 );


res = ifNil( cli:set( '/path/to/key' ) );
ifNotEqual( res.status, 201 );
res = ifNil( cli:readdir( '/path/to/key' ) );
ifNotEqual( res.status, 404 );

-- cleanup
ifNil( cli:rmdir( '/path', recursive ) );

