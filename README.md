# nginx
[![](https://images.microbadger.com/badges/version/manuku/nginx.svg)](https://microbadger.com/images/manuku/nginx "Get your own version badge on microbadger.com")

编译[nginx](https://nginx.org/) v1.11.13 源码，编译参数
```
--with-select_module 
--with-poll_module 
--with-threads 
--with-file-aio 
--with-http_ssl_module 
--with-http_v2_module 
--with-http_realip_module 
--with-http_addition_module 
--with-http_xslt_module=dynamic 
--with-http_image_filter_module=dynamic 
--with-http_geoip_module=dynamic 
--with-http_sub_module 
--with-http_dav_module 
--with-http_flv_module 
--with-http_mp4_module 
--with-http_gunzip_module 
--with-http_gzip_static_module 
--with-http_auth_request_module 
--with-http_random_index_module 
--with-http_secure_link_module 
--with-http_degradation_module 
--with-http_slice_module 
--with-http_stub_status_module 
--with-mail=dynamic 
--with-mail_ssl_module 
--with-stream=dynamic 
--with-stream_ssl_module 
--with-stream_realip_module 
--with-stream_geoip_module=dynamic 
--with-stream_ssl_preread_module 
--with-compat 
--with-openssl 
--with-openssl-opt=no-nextprotoneg 
--with-zlib 
--with-pcre 
--with-pcre-jit
```
并安装如下模块
- [lua-nginx-module](https://github.com/openresty/lua-nginx-module) v0.10.10
- [LuaJIT](https://luajit.org/) v2.0.5
- [lua-upstream-nginx-module](https://github.com/openresty/lua-upstream-nginx-module) v0.07
- [ngx_http_dyups_module](https://github.com/yzprofile/ngx_http_dyups_module) a5e75737e04ff3e5040a80f5f739171e96c3359c
- [ngx_cache_purge](https://github.com/FRiCKLE/ngx_cache_purge) v2.3
