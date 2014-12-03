local Etcd = require('etcd.resty');
local cli = ifNil( Etcd.new({ gateway = '/proxy_gateway' }) );
local res, cfg, val;

res = ifNil( cli:adminMachines() );
ifNotEqual( res.status, 200 );

res = ifNil( cli:adminConfig() );
ifNotEqual( res.status, 200 );

cfg = res.body;
val = cfg.syncInterval;
cfg.syncInterval = val + val;
res = ifNil( cli:setAdminConfig( cfg ) );
ifNotEqual( res.status, 200 );

res = ifNil( cli:adminConfig() );
ifNotEqual( res.status, 200 );
ifNotEqual( cfg.syncInterval, res.body.syncInterval );

res.body.syncInterval = val;
res = ifNil( cli:setAdminConfig( res.body ) );
ifNotEqual( res.status, 200 );
