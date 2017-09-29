FROM debian:jessie

MAINTAINER ruan jiefeng <runjf@qq.com>

RUN apt-get update \
		&& apt-get install -y nginx-extras \
		&& rm -rf /var/lib/apt/lists/*


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# EXPOSE 80 443

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD [""]
