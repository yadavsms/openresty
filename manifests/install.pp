
# == class: openresty::install
class openresty::install inherits openresty {

        $dependency = ['wget', 'libreadline-dev', 'libncurses5-dev', 'libpcre3-dev', 'libssl-dev', 'perl', 'make', 'build-essential']

       package {$dependency: ensure => 'installed',
          before  => Exec['download ngx_openresty'],
       }

       exec { "download ngx_openresty":
          command => "wget https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz -O /tmp/ngx_openresty-1.9.3.1.tar.gz",
          cwd     => "/tmp/",
	  path 	  => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
          before  => Exec['extract ngx_openresty'],
       }

        exec { "extract ngx_openresty":
	  command => "tar -xf /tmp/ngx_openresty-1.9.3.1.tar.gz -C /tmp/",
          cwd     => "/tmp/",
	  path 	  => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
	  require => Exec['download ngx_openresty'],
        }

        exec { "configure ngx_openresty":
	  command  => "perl configure --prefix=/opt/openresty --with-pcre --with-pcre-jit --with-luajit --without-http_redis2_module  --without-http_redis_module  --without-http_rds_json_module  --without-http_echo_module --without-http_rds_csv_module --without-http_xss_module --without-http_coolkit_module --without-http_set_misc_module --without-http_form_input_module --without-http_srcache_module --without-http_lua_module  --without-http_lua_upstream_module   --without-http_headers_more_module --without-http_array_var_module --without-http_memc_module --without-ngx_devel_kit_module",
          cwd     => "/tmp/ngx_openresty-1.9.3.1/",
	  path 	  => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
	  require => Exec['extract ngx_openresty']
        }


        exec { "make ngx_openresty":
	  command => "make",
          cwd     => "/tmp/ngx_openresty-1.9.3.1/",
	  path 	  => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
	  require => Exec['configure ngx_openresty']
        }

        exec { "install ngx_openresty":
          command => "make install",
          cwd     => "/tmp/ngx_openresty-1.9.3.1/",
	  path 	  => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
          require => Exec['make ngx_openresty']
        }
}
