# HTML NGINX CONFIGURATION

server {
	
	listen 80;
	server_name v1.ppmroadmap.com www.v1.ppmroadmap.com;

	ssl off;

	access_log   /var/log/nginx/v1.ppmroadmap.com.access.log;
	error_log    /var/log/nginx/v1.ppmroadmap.com.error.log;

	root /var/www/v1.ppmroadmap.com/htdocs;
	index index.html index.htm;

	location / {
		try_files $uri $uri/ /index.html; 
	}

	include common/locations.conf;

}
