server {
    listen 80;

    root /var/www/lunchpoint.com/frontend/web;
    index index.php index.html;

    server_name lunchpoint.bigdig.com.ua;

    charset utf-8;

    # location ~* ^.+\.(jpg|jpeg|gif|png|ico|css|pdf|ppt|txt|bmp|rtf|js)$ {
    #    access_log off;
    #    expires max;
    # }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location /manager {
        try_files $uri $uri/ /manager/index.php$is_args$args;
    }


    client_max_body_size 32m;

    # There is a VirtualBox bug related to sendfile that can lead to
    # corrupted files, if not turned-off
    # sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass php-fpm;
        fastcgi_index index.php;
        include fastcgi_params;

        ## Cache
        # fastcgi_pass_header Cookie; # fill cookie valiables, $cookie_phpsessid for exmaple
        # fastcgi_ignore_headers Cache-Control Expires Set-Cookie; # Use it with caution because it is cause SEO problems
        # fastcgi_cache_key "$request_method|$server_addr:$server_port$request_uri|$cookie_phpsessid"; # generating unique key
        # fastcgi_cache fastcgi_cache; # use fastcgi_cache keys_zone
        # fastcgi_cache_path /tmp/nginx/ levels=1:2 keys_zone=fastcgi_cache:16m max_size=256m inactive=1d;
        # fastcgi_temp_path  /tmp/nginx/temp 1 2; # temp files folder
        # fastcgi_cache_use_stale updating error timeout invalid_header http_500; # show cached page if error (even if it is outdated)
        # fastcgi_cache_valid 200 404 10s; # cache lifetime for 200 404;
        # or fastcgi_cache_valid any 10s; # use it if you want to cache any responses
    }
}

## PHP-FPM Servers ##
upstream php-fpm {
    server php73:9000;
}

## MISC ##
### WWW Redirect ###
server {
    listen       80;
    server_name  www.lunchpoint.bigdig.com.ua;
    return       301 http://lunchpoint.bigdig.com.ua$request_uri;
}
