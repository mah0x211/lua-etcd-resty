local fork = require('process').fork;
local Etcd = require('etcd.resty');

-- with default timeout 3 sec
local cli = ifNil( Etcd.new({
    gateway = '/proxy_gateway',
    timeout = 5
}));
local key = '/path/to/key';
local val = 'hello world';
local recursive = true;
local res, idx;

-- set key by child process
local function setByChild( afterSec )
    local pid = ifEqual( fork(), -1 );
    
    if pid == 0 then
        sleep( afterSec or 1 );
        res = ifNil( cli:set( key, val .. os.time() ) );
        ifNotEqual( res.status, 200 );
        os.exit(0);
    end
end

-- mkdir by child process
local function mkdirByChild( afterSec )
    local pid = ifEqual( fork(), -1 );
    
    if pid == 0 then
        sleep( afterSec or 1 );
        res = ifNil( cli:mkdir( key .. os.time() ) );
        ifNotEqual( res.status, 201 );
        os.exit(0);
    end
end


-- cleanup
ifNil( cli:rmdir( '/path', true ) );

res = ifNil( cli:set( key, val ) );
ifNotEqual( res.status, 201 );
idx = res.body.node.modifiedIndex;


-- wait
setByChild();
res = ifNil( cli:wait( key ) );
ifNotEqual( res.status, 200 );
ifNotEqual( res.body.prevNode.modifiedIndex, idx );
idx = res.body.node.modifiedIndex;


-- with with index
setByChild();
res = ifNil( cli:wait( key, idx + 1 ) );
ifNotEqual( res.status, 200 );
ifNotEqual( res.body.prevNode.modifiedIndex, idx );
idx = res.body.node.modifiedIndex;

setByChild();
setByChild(2);
res = ifNil( cli:wait( key, idx + 2 ) );
ifNotEqual( res.status, 200 );
ifNotEqual( res.body.prevNode.modifiedIndex, idx + 1 );
idx = res.body.node.modifiedIndex;


-- wait recursive
res = ifNil( cli:readdir( '/path', true ) );
setByChild();
res = ifNil( cli:waitdir( '/path' ) );
ifNotEqual( res.status, 200 );
ifNotEqual( res.body.prevNode.modifiedIndex, idx );
idx = res.body.node.modifiedIndex;

mkdirByChild();
res = ifNil( cli:waitdir( '/path' ) );
ifNotEqual( res.status, 200 );
idx = res.body.node.modifiedIndex;


-- wait recursive with index
setByChild();
res = ifNil( cli:waitdir( '/path', idx + 1 ) );
ifNotEqual( res.status, 200 );
idx = res.body.node.modifiedIndex;

setByChild();
setByChild(2);
res = ifNil( cli:waitdir( '/path', idx + 2 ) );
ifNotEqual( res.status, 200 );
ifNotEqual( res.body.prevNode.modifiedIndex, idx + 1 );
idx = res.body.node.modifiedIndex;


-- timeout
res = ifNil( cli:wait( key ) );
ifNotEqual( res.status, 408 );

-- timeout after 1 sec
res = ifNil( cli:wait( key, nil, 1 ) );
ifNotEqual( res.status, 408 );

-- wait forever
setByChild( 3 ); -- update key after 3 seconds
res = ifNil( cli:wait( key, nil, 0 ) );
ifNotEqual( res.status, 200 );


-- cleanup
ifNil( cli:rmdir( '/path', true ) );
