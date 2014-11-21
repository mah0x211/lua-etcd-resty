package = "etcd-resty"
version = "1.0.0-1"
source = {
    url = "git://github.com/mah0x211/lua-etcd-resty.git",
    tag = "v1.0.0"
}
description = {
    summary = "etcd client module for OpenResty.",
    homepage = "https://github.com/mah0x211/lua-etcd-resty", 
    license = "MIT/X11",
    maintainer = "Masatoshi Teruya"
}
dependencies = {
    "lua >= 5.1",
    "halo >= 1.1",
    "util >= 1.1",
    "httpcli-resty >= 1.0",
    "etcd >= 0.9.0"
}
build = {
    type = "builtin",
    modules = {
        ["etcd.resty"] = "resty.lua"
    }
}

