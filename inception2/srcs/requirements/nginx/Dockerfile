FROM	alpine:3.21

RUN		apk update
RUN		apk upgrade

RUN		apk add nginx
RUN		apk add openssl

COPY	conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN		mkdir -p /etc/nginx/ssl
RUN		openssl req -x509 -nodes \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=tde-la-r/UID=tde-la-r"

EXPOSE	443

CMD		[ "nginx", "-g", "daemon off;" ]
