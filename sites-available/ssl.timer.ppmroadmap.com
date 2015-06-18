# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name
#
server {
  listen [::]:80;
  listen 80;

  # listen on both hosts
  server_name timer.ppmroadmap.com www.timer.ppmroadmap.com;

  # and redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://timer.ppmroadmap.com$request_uri;
}





server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # listen on the wrong host
  server_name www.timer.ppmroadmap.com;

  ssl on;

  include /etc/nginx/conf.d/h5bp/directive-only/ssl.conf;

  # and redirect to the non-www host (declared below)
  return 301 https://timer.ppmroadmap.com$request_uri;
}





server {

  # listen [::]:443 ssl spdy accept_filter=dataready;  # for FreeBSD
  # listen 443 ssl spdy accept_filter=dataready;  # for FreeBSD
  # listen [::]:443 ssl spdy deferred;  # for Linux
  # listen 443 ssl spdy deferred;  # for Linux
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # The host name to respond to
  server_name timer.ppmroadmap.com;

  include /etc/nginx/conf.d/h5bp/directive-only/ssl.conf;

  # Path for static files
  root /var/www/timer.ppmroadmap.com/production/current;

  #Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 404 /404.html;

  # Include the basic h5bp config set
  include /etc/nginx/conf.d/h5bp/basic.conf;
}
