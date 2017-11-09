# FROM centos:7
FROM buildpack-deps:stretch

MAINTAINER ruan jiefeng <runjf@qq.com>

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get update \
    && apt-get install -y libgd2-xpm-dev libgeoip-dev \
    && rm -rf /var/lib/apt/lists/*

# RUN apt-get update \
#       && apt-get install -y wget
# RUN apt-get install -y build-essential

# RUN yum groupinstall -y --setopt=tsflags=nodocs 'Development Tools'
# RUN yum install -y --setopt=tsflags=nodocs epel-release
# RUN yum install -y --setopt=tsflags=nodocs perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel
# RUN yum install -y --setopt=tsflags=nodocs wget

# in rhel 6.8 iso
# rpm -ivh zlib-devel-1.2.3-29.el6.x86_64.rpm

ENV LUA_NGINX_MODULE_VERSION 0.10.10
ENV NGX_DEVEL_KIT_VERSION 0.3.0
ENV PCRE_VERSION 8.41
ENV LUAJIT_VERSION 2.0.5
ENV NGINX_VERSION 1.11.13
ENV OPENSSL_VERSION 1.0.2m
ENV ZLIB_VERSION 1.2.11
ENV LUA_UPSTREAM_NGINX_MODULE_VERSION 0.07
ENV NGX_HTTP_DYUPS_MODULE_VERSION a5e75737e04ff3e5040a80f5f739171e96c3359c

WORKDIR /build

# lua-nginx-module
RUN wget -O lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz https://codeload.github.com/openresty/lua-nginx-module/tar.gz/v${LUA_NGINX_MODULE_VERSION}
RUN tar xzvf lua-nginx-module-${LUA_NGINX_MODULE_VERSION}.tar.gz

# ngx_devel_kit
RUN wget -O ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz https://codeload.github.com/simpl/ngx_devel_kit/tar.gz/v${NGX_DEVEL_KIT_VERSION}
RUN tar xzvf ngx_devel_kit-${NGX_DEVEL_KIT_VERSION}.tar.gz

# pcre
RUN wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz
RUN tar xzvf pcre-${PCRE_VERSION}.tar.gz

# luajit
RUN wget https://luajit.org/download/LuaJIT-${LUAJIT_VERSION}.tar.gz
RUN tar xzvf LuaJIT-${LUAJIT_VERSION}.tar.gz
RUN cd LuaJIT-${LUAJIT_VERSION}/ \
    && make PREFIX=/usr/local/lj2 \
    && make install PREFIX=/usr/local/lj2

# tell nginx's build system where to find LuaJIT 2.0:
# RUN export LUAJIT_LIB=/usr/local/lj2/lib
# RUN export LUAJIT_INC=/usr/local/lj2/include/luajit-2.0

# tell nginx's build system where to find LuaJIT 2.1:
# export LUAJIT_LIB=/path/to/luajit/lib
# export LUAJIT_INC=/path/to/luajit/include/luajit-2.1

# or tell where to find Lua if using Lua instead:
# export LUA_LIB=/path/to/lua/lib
# export LUA_INC=/path/to/lua/include

# nginx
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar xzvf nginx-${NGINX_VERSION}.tar.gz
# RUN cd nginx-${NGINX_VERSION}

# openssl
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
RUN tar xzvf openssl-${OPENSSL_VERSION}.tar.gz

# zlib
RUN wget https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
RUN tar xzvf zlib-${ZLIB_VERSION}.tar.gz

# lua-upstream-nginx-module
RUN wget -O lua-upstream-nginx-module-${LUA_UPSTREAM_NGINX_MODULE_VERSION}.tar.gz https://codeload.github.com/openresty/lua-upstream-nginx-module/tar.gz/v${LUA_UPSTREAM_NGINX_MODULE_VERSION}
RUN tar xzvf lua-upstream-nginx-module-${LUA_UPSTREAM_NGINX_MODULE_VERSION}.tar.gz

# ngx_http_dyups_module
RUN wget -O ngx_http_dyups_module-${NGX_HTTP_DYUPS_MODULE_VERSION}.tar.gz https://codeload.github.com/yzprofile/ngx_http_dyups_module/tar.gz/${NGX_HTTP_DYUPS_MODULE_VERSION}
RUN tar xzvf ngx_http_dyups_module-${NGX_HTTP_DYUPS_MODULE_VERSION}.tar.gz

# Here we assume Nginx is to be installed under /opt/nginx/.
RUN cd nginx-${NGINX_VERSION} \
    && export LUAJIT_LIB=/usr/local/lj2/lib \
    && export LUAJIT_INC=/usr/local/lj2/include/luajit-2.0 \
    && ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --with-select_module \
        --with-poll_module \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-mail=dynamic \
        --with-mail_ssl_module \
        --with-stream=dynamic \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-stream_ssl_preread_module \
        --with-compat \
        --with-openssl=../openssl-${OPENSSL_VERSION} \
        --with-openssl-opt=no-nextprotoneg \
        --with-zlib=../zlib-${ZLIB_VERSION} \
        --with-pcre="../pcre-${PCRE_VERSION}" \
        --with-pcre-jit \
        --with-ld-opt="-Wl,-rpath,/usr/local/lj2/lib" \
        --add-module=../ngx_devel_kit-${NGX_DEVEL_KIT_VERSION} \
        --add-module=../lua-nginx-module-${LUA_NGINX_MODULE_VERSION} \
        --add-module=../lua-upstream-nginx-module-${LUA_UPSTREAM_NGINX_MODULE_VERSION} \
        --add-module=../ngx_http_dyups_module-${NGX_HTTP_DYUPS_MODULE_VERSION} \
        --with-debug \
    && make -j2 \
    && make install

# Note that you may also want to add `./configure` options which are used in your
# current nginx build.
# You can get usually those options using command nginx -V

# you can change the parallism number 2 below to fit the number of spare CPU cores in your
# machine.
# RUN make -j2
# RUN make install

WORKDIR /


# forward request and error logs to docker log collector
RUN mkdir -p /var/log/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# EXPOSE 80 443

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD [""]
