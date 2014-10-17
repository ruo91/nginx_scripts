#!/bin/bash
echo
echo -ne "\033[33m ################################################\033[0m \n"
echo -ne "\033[33m # The build automation scripts for OpenResty	#\033[0m \n"
echo -ne "\033[33m # Maintainer: Yongbok Kim (ruo91@yongbok.net)	#\033[0m \n"
echo -ne "\033[33m ################################################\033[0m \n"
echo

# Step 1. Please enter configure variable of OpenResty
function configure_variable_of_openresty {
echo
echo -ne "\033[33m- Step 1. Please enter version of OpenResty\033[0m \n"
echo -ne "\033[33m- Verify URL: http://openresty.org/\033[0m \n"
echo -ne "\033[33m- ex) auto or 1.7.2.1: \033[0m: "

read input_the_version_for_openresty
case ${input_the_version_for_openresty} in
	1*|2*|3*|4*|5*)
		OPENRESTY_VER=$input_the_version_for_openresty
		google_pagespeed
		;;
	auto)
		curl -L -o /tmp/openresty_ver "https://raw.githubusercontent.com/openresty/ngx_openresty/master/util/ver"
		OPENRESTY_VER=`chmod a+x /tmp/openresty_ver && /tmp/openresty_ver` && rm -f /tmp/openresty_ver
		google_pagespeed
		;;  
	*)
		echo -ne "\033[31m- Does not support version!\033[0m \n"
		echo -ne "\033[31m- Please check the version for OpenResty!\033[0m \n"
		exit 0
		;;
esac
}

# Step 2. Do you want to install of google pagespeed module? (ngx_pagespeed)
function google_pagespeed {
echo
echo -ne "\033[33m- Step 2. Do you want to install of google pagespeed module?\033[0m"
echo -ne "\033[33m yes(y) or no(n): \033[0m"

read input_the_google_pagespeed
case ${input_the_google_pagespeed} in
	y|Y|yes|Yes|YES)
		GOOGLE_PAGESPEED=y
		install_packages
		;;
	n|N|no|NO)
		GOOGLE_PAGESPEED=n
		install_packages
		;;
	*)
		echo -ne "\033[31m- Does not support answer!\033[0m \n"
		echo -ne "\033[31m- yes(y) or no(n)\033[0m \n"
		exit 0
		;;
esac
}

# Step 3. The requirements of packages for OpenResty
function install_packages {
DEBIAN=`cat /etc/issue | head -n 1 | awk '{printf $1}'`
REDHAT=`cat /etc/*-release | head -n 1 | awk '{printf $1}'`

if [ "$DEBIAN" == "Debian" ]; then
	case $GOOGLE_PAGESPEED in
		y)
			apt-get update && apt-get install -y git build-essential libreadline6-dev \
			ncurses-dev libpcre++-dev libssl-dev libgeoip-dev libxml2-dev libxslt-dev libgd2-xpm-dev libperl-dev zlib1g-dev libpcre3 libpcre3-dev
			;;

		n)
			apt-get update && apt-get install -y build-essential libreadline6-dev \
			ncurses-dev libpcre++-dev libssl-dev libgeoip-dev libxml2-dev libxslt-dev libgd2-xpm-dev libperl-dev zlib1g-dev libpcre3 libpcre3-dev
			;;
	esac

	if [ "`grep nginx /etc/group | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx groups already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	elif [ "`grep nginx /etc/passwd | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx user already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		groupadd -g 82 nginx && useradd -d /var/www -c "Nginx User" -u 82 -g 82 -s /sbin/nologin nginx
	fi

	sleep 5
	echo -ne "\033[33m - Step 3. The requirements of packages for OpenResty: [\033[0m"
	echo -ne "\033[32m Complete\033[0m"
	echo -ne "\033[33m ]\033[0m \n"
	echo

elif [ "$DEBIAN" == "Ubuntu" ]; then
	case $GOOGLE_PAGESPEED in
		y)
			apt-get update && apt-get install -y git build-essential libreadline6-dev \
			ncurses-dev libpcre++-dev libssl-dev libgeoip-dev libxml2-dev libxslt-dev libgd2-xpm-dev libperl-dev zlib1g-dev libpcre3 libpcre3-dev
			;;

		n)
			apt-get update && apt-get install -y build-essential libreadline6-dev \
			ncurses-dev libpcre++-dev libssl-dev libgeoip-dev libxml2-dev libxslt-dev libgd2-xpm-dev libperl-dev zlib1g-dev libpcre3 libpcre3-dev
			;;
	esac

	if [ "`grep nginx /etc/group | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx groups already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	elif [ "`grep nginx /etc/passwd | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx user already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		groupadd -g 82 nginx && useradd -d /var/www -c "Nginx User" -u 82 -g 82 -s /sbin/nologin nginx
	fi

	sleep 5
	echo -ne "\033[33m - Step 3. The requirements of packages for OpenResty: [\033[0m"
	echo -ne "\033[32m Complete\033[0m"
	echo -ne "\033[33m ]\033[0m \n"
	echo

elif [ "$REDHAT" == "CentOS" ]; then
	yum groupinstall -y "Development Tools"

	case $GOOGLE_PAGESPEED in
		y)
			yum install -y git readline-devel pcre-devel openssl-devel \
			ncurses-devel openssl-devel libxml2-devel libxslt-devel gd-devel zlib-devel perl-devel perl-ExtUtils-Embed

			if [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "5" ]; then
				curl -LO "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm"
				rpm -ivh rpmforge-release*.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y git geoip-devel

			elif [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "6" ]; then
				rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y geoip-devel

			elif [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "7" ]; then
				rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y geoip-devel
			fi
			;;


		n)
			yum install -y readline-devel pcre-devel openssl-devel \
			ncurses-devel openssl-devel libxml2-devel libxslt-devel gd-devel zlib-devel perl-devel perl-ExtUtils-Embed

			if [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "5" ]; then
				curl -LO "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm"
				rpm -ivh rpmforge-release*.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y geoip-devel

			elif [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "6" ]; then
				rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y geoip-devel

			elif [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "7" ]; then
				rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
				sed -i '/^enabled/ s:.*:enabled = 0:' /etc/yum.repos.d/rpmforge.repo
				rm -f rpmforge-release*
				yum install --enablerepo=rpmforge -y geoip-devel
			fi
			;;
	esac

	if [ "`grep nginx /etc/group | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx groups already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	elif [ "`grep nginx /etc/passwd | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx user already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		groupadd -g 82 nginx && useradd -d /var/www -c "Nginx User" -u 82 -g 82 -s /sbin/nologin nginx
	fi

	sleep 5
	echo -ne "\033[33m - Step 3. The requirements of packages for OpenResty: [\033[0m"
	echo -ne "\033[32m Complete\033[0m"
	echo -ne "\033[33m ]\033[0m \n"
	echo

elif [ "$REDHAT" == "Fedora" ]; then
	yum groupinstall -y "Development Tools"

		case $GOOGLE_PAGESPEED in
			y)
				yum install -y git readline-devel pcre-devel openssl-devel \
				geoip-devel ncurses-devel openssl-devel libxml2-devel libxslt-devel gd-devel zlib-devel perl-devel perl-ExtUtils-Embed
				;;

			n)
				yum install -y readline-devel pcre-devel openssl-devel \
				geoip-devel ncurses-devel openssl-devel libxml2-devel libxslt-devel gd-devel zlib-devel perl-devel perl-ExtUtils-Embed
				;;
		esac

	if [ "`grep nginx /etc/group | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx groups already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	elif [ "`grep nginx /etc/passwd | cut -f 1 -d ":"`" == "nginx"  ]; then
		echo -ne "\033[33m - Nginx user already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		groupadd -g 82 nginx && useradd -d /var/www -c "Nginx User" -u 82 -g 82 -s /sbin/nologin nginx
	fi

	sleep 5
	echo -ne "\033[33m - Step 3. The requirements of packages for OpenResty: [\033[0m"
	echo -ne "\033[32m Complete\033[0m"
	echo -ne "\033[33m ]\033[0m \n"
	echo

else
	echo -ne "\033[31m- Does not support that linux distributions from scripts.\033[0m \n"
	echo -ne "\033[31m- Error: Step 3. The requirements of packages for OpenResty -> function install_packages\033[0m \n"
	exit 0
fi
}

# Step 4. Build for OpenResty
function build_openresty {
# Variables for OpenResty
OPENRESTY_UGID=nginx
OPENRESTY_PREFIX=/etc/openresty
OPENRESTY_SBIN_PATH=$OPENRESTY_PREFIX/sbin/nginx
OPENRESTY_PID_PATH=$OPENRESTY_PREFIX/tmp/run/openresty.pid
OPENRESTY_LOCK_PATH=$OPENRESTY_PREFIX/tmp/run/openresty.lock
OPENRESTY_ERROR_LOGS=$OPENRESTY_PREFIX/nginx/logs/openresty-error.log

curl -LO "http://openresty.org/download/ngx_openresty-$OPENRESTY_VER.tar.gz"
tar xzvf ngx_openresty-$OPENRESTY_VER.tar.gz
cd ngx_openresty-$OPENRESTY_VER

case $GOOGLE_PAGESPEED in
	y)
		# Psol
		curl -L -o /tmp/ngx_pagespeed_config "https://raw.githubusercontent.com/pagespeed/ngx_pagespeed/master/config"
		cat /tmp/ngx_pagespeed_config | grep "dl.google.com" > /tmp/nps_ver && sed -i 's/gz\"/gz/g' /tmp/nps_ver
		PSOL="`cat /tmp/nps_ver | awk '{printf $5}'`" && rm -f /tmp/{ngx_pagespeed_config,nps_ver}

		# Google Page Speed
		git clone https://github.com/pagespeed/ngx_pagespeed.git
		cd ngx_pagespeed && curl -LO "$PSOL" && mod_pagespeed_dir="`pwd`/psol/include"
		tar xzvf *.tar.gz && cd ..

		./configure --prefix=$OPENRESTY_PREFIX \
		--user=$OPENRESTY_UGID \
		--group=$OPENRESTY_UGID \
		--sbin-path=$OPENRESTY_SBIN_PATH \
		--conf-path=$OPENRESTY_PREFIX/nginx/nginx.conf \
		--error-log-path=$OPENRESTY_ERROR_LOGS \
		--pid-path=$OPENRESTY_PID_PATH \
		--lock-path=$OPENRESTY_LOCK_PATH \
		--add-module=ngx_pagespeed \
		--with-file-aio \
		--with-ipv6 \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_xslt_module \
		--with-http_image_filter_module \
		--with-http_geoip_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_iconv_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_degradation_module \
		--with-http_stub_status_module \
		--with-http_perl_module \
		--with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm \
		--http-client-body-temp-path=$OPENRESTY_PREFIX/tmp/client_body_temp \
		--http-proxy-temp-path=$OPENRESTY_PREFIX/tmp/proxy_temp \
		--http-fastcgi-temp-path=$OPENRESTY_PREFIX/tmp/fastcgi_temp
		make && make install && cd .. && rm -rf ngx*
		echo '' >> /etc/profile
		echo '# OpenResty' >> /etc/profile
		echo "export OPENRESTY_PREFIX=$OPENRESTY_PREFIX" >> /etc/profile
		echo 'export PATH=$PATH:$OPENRESTY_PREFIX/sbin' >> /etc/profile
		source /etc/profile

		sleep 5
		if [ -d "$OPENRESTY_PREFIX/nginx/default" ]; then
			echo -ne "\033[33m - The \"$OPENRESTY_PREFIX/nginx/default\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			mkdir $OPENRESTY_PREFIX/nginx/default
			mv $OPENRESTY_PREFIX/nginx/*.default $OPENRESTY_PREFIX/nginx/default
		fi

		sleep 5
		if [ -d "$OPENRESTY_PREFIX/tmp/client_body_temp" ]; then
			echo -ne "\033[33m - The \"client_body_temp, proxy_temp, fastcgi_temp\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			mkdir -p $OPENRESTY_PREFIX/tmp/{client_body_temp,proxy_temp,fastcgi_temp,run}
		fi
		;;

	n)
		./configure --prefix=$OPENRESTY_PREFIX \
		--user=$OPENRESTY_UGID \
		--group=$OPENRESTY_UGID \
		--sbin-path=$OPENRESTY_SBIN_PATH \
		--conf-path=$OPENRESTY_PREFIX/nginx/nginx.conf \
		--error-log-path=$OPENRESTY_ERROR_LOGS \
		--pid-path=$OPENRESTY_PID_PATH \
		--lock-path=$OPENRESTY_LOCK_PATH \
		--with-file-aio \
		--with-ipv6 \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_xslt_module \
		--with-http_image_filter_module \
		--with-http_geoip_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_iconv_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_degradation_module \
		--with-http_stub_status_module \
		--with-http_perl_module \
		--with-pcre --with-pcre-jit --with-md5-asm --with-sha1-asm \
		--http-client-body-temp-path=$OPENRESTY_PREFIX/tmp/client_body_temp \
		--http-proxy-temp-path=$OPENRESTY_PREFIX/tmp/proxy_temp \
		--http-fastcgi-temp-path=$OPENRESTY_PREFIX/tmp/fastcgi_temp
		make && make install && cd .. && rm -rf ngx*
		echo '' >> /etc/profile
		echo '# OpenResty' >> /etc/profile
		echo "export OPENRESTY_PREFIX=$OPENRESTY_PREFIX" >> /etc/profile
		echo 'export PATH=$PATH:$OPENRESTY_PREFIX/sbin' >> /etc/profile
		source /etc/profile

		sleep 5
		if [ -d "$OPENRESTY_PREFIX/nginx/default" ]; then
			echo -ne "\033[33m - The \"$OPENRESTY_PREFIX/nginx/default\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			mkdir $OPENRESTY_PREFIX/nginx/default
			mv $OPENRESTY_PREFIX/nginx/*.default $OPENRESTY_PREFIX/nginx/default
		fi

		sleep 5
		if [ -d "$OPENRESTY_PREFIX/tmp" ]; then
			echo -ne "\033[33m - The \"$OPENRESTY_PREFIX/tmp\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			mkdir -p $OPENRESTY_PREFIX/tmp/{client_body_temp,proxy_temp,fastcgi_temp,run}
		fi
		;;
esac

sleep 5
echo -ne "\033[33m - Step 4. Build for OpenResty: [\033[0m"
echo -ne "\033[32m Complete\033[0m"
echo -ne "\033[33m ]\033[0m \n"
echo
}

# Step 5. Download for init scripts
function init_scripts {
SCRIPTS_URL=https://raw.githubusercontent.com/ruo91/nginx_scripts/master/openresty
INIT_D_PATH=/etc/init.d/openresty
SYSTEMD_PATH=/etc/systemd/system/openresty.service

# Debian
if [ "$DEBIAN" == "Debian" ]; then
	if [ -f "$INIT_D_PATH" ]; then
		echo -ne "\033[33m - The \"$INIT_D_PATH\" already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		curl -L -o $INIT_D_PATH "$SCRIPTS_URL/initd_scripts/debian_openresty"
		chmod a+x $INIT_D_PATH
		update-rc.d -f openresty defaults
	fi

	if [ -d "$OPENRESTY_PREFIX/nginx/vhosts" ]; then
		echo -ne "\033[33m - The config files or directory already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		curl -LO "$SCRIPTS_URL/config/config_for_openresty_pagespeed.tar.gz"
		tar xzvf config_for_openresty_pagespeed.tar.gz -C /etc && rm -f config_for_openresty_pagespeed.tar.gz
	fi

# Ubuntu
elif [ "$DEBIAN" == "Ubuntu" ]; then
	if [ -f "$INIT_D_PATH" ]; then
		echo -ne "\033[33m - The \"$INIT_D_PATH\" already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		curl -L -o $INIT_D_PATH "$SCRIPTS_URL/initd_scripts/ubuntu_openresty"
		chmod a+x $INIT_D_PATH
		update-rc.d -f openresty defaults
	fi

	if [ -d "$OPENRESTY_PREFIX/nginx/vhosts" ]; then
		echo -ne "\033[33m - The config files or directory already exists. [\033[0m"
		echo -ne "\033[31m SKIP\033[0m"
		echo -ne "\033[33m ]\033[0m \n"

	else
		curl -LO "$SCRIPTS_URL/config/config_for_openresty_pagespeed.tar.gz"
		tar xzvf config_for_openresty_pagespeed.tar.gz -C /etc && rm -f config_for_openresty_pagespeed.tar.gz
	fi

# CentOS
elif [ "$REDHAT" == "CentOS" ]; then
	if [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "7" ]; then
		if [ -f "$SYSTEMD_PATH" ]; then
			echo -ne "\033[33m - The \"$SYSTEMD_PATH\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			curl -LO "$SCRIPTS_URL/systemd_scripts/systemd.tar.gz"
			tar xzf systemd.tar.gz -C /
			systemctl enable openresty
		fi

		else
			if [ -f "$INIT_D_PATH" ]; then
			echo -ne "\033[33m - The \"$INIT_D_PATH\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

			else
				curl -L -o $INIT_D_PATH "$SCRIPTS_URL/initd_scripts/redhat_openresty"
				chmod a+x $INIT_D_PATH
				chkconfig --add openresty
			fi
		fi

# Fedora
elif [ "$REDHAT" == "Fedora" ]; then
	# Systemd for Fedora 15 or higher
	if [ "`rpm -q --queryformat '%{VERSION}' fedora-release`" -ge "15" ]; then
		if [ -f "$SYSTEMD_PATH" ]; then
			echo -ne "\033[33m - The \"$SYSTEMD_PATH\" already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			curl -LO "$SCRIPTS_URL/systemd_scripts/systemd.tar.gz"
			tar xzf systemd.tar.gz -C /
			systemctl enable openresty
		fi

		else
			if [ -f "$INIT_D_PATH" ]; then
				echo -ne "\033[33m - The \"$INIT_D_PATH\" already exists. [\033[0m"
				echo -ne "\033[31m SKIP\033[0m"
				echo -ne "\033[33m ]\033[0m \n"

			else
				curl -L -o $INIT_D_PATH "$SCRIPTS_URL/initd_scripts/redhat_openresty"
				chmod a+x $INIT_D_PATH
				chkconfig --add openresty
			fi
		fi

else
	echo -ne "\033[31m- Does not support that linux distributions from scripts.\033[0m \n"
	echo -ne "\033[31m- Error: Step 5. Create of init.d scripts -> function init_scripts[0m \n"
	exit 0
fi
}

# Step 6. Config files for nginx
function nginx_conf {
cd $OPENRESTY_PREFIX/nginx

case $GOOGLE_PAGESPEED in
	y)
		if [ -d "$OPENRESTY_PREFIX/nginx/vhosts" ]; then
			echo -ne "\033[33m - The config files or directory already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			curl -LO "$SCRIPTS_URL/config/config_for_openresty_pagespeed.tar.gz"
			tar xzf config_for_openresty_pagespeed.tar.gz -C /etc && rm -f config_for_openresty_pagespeed.tar.gz
		fi
		;;

	n)
		if [ -d "$OPENRESTY_PREFIX/nginx/vhosts" ]; then
			echo -ne "\033[33m - The config files or directory already exists. [\033[0m"
			echo -ne "\033[31m SKIP\033[0m"
			echo -ne "\033[33m ]\033[0m \n"

		else
			curl -LO "$SCRIPTS_URL/config/config_for_openresty.tar.gz"
			tar xzf config_for_openresty.tar.gz -C /etc && rm -f config_for_openresty.tar.gz
		fi
		;;
esac
}

# Main
# Do you want to really a build?
echo -ne "\033[33m- Do you want to really a build?\033[0m"
echo -ne "\033[33m yes(y) or no(n): \033[0m"

read yes_or_no
case ${yes_or_no} in
	y|Y|yes|Yes|YES)
		configure_variable_of_openresty
		build_openresty
		init_scripts
		nginx_conf
		;;

	n|N|no|No|NO)
		exit 0
		;;
	*)
		echo -ne "\033[31m- Your answer: yes(y) or no(n)\033[0m \n" >&2
		exit 0
		;;
esac

if [ "$DEBIAN" == "Debian" ]; then
	echo
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
	echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
	echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m  Start:		service openresty start				\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo

elif [ "$DEBIAN" == "Ubuntu" ]; then
	echo
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
	echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
	echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo -ne "\033[33m  Start:		service openresty start				\033[0m \n"
	echo -ne "\033[33m ########################################################\033[0m \n"
	echo

elif [ "$REDHAT" == "CentOS" ]; then
	if [ "`rpm -q --queryformat '%{VERSION}' centos-release`" -eq "7" ]; then
			echo
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
			echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
			echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Start:		systemctl start openresty				\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo

		else
			echo
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
			echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
			echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Start:		service openresty start				\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo
		fi

elif [ "$REDHAT" == "Fedora" ]; then
		if [ "`rpm -q --queryformat '%{VERSION}' fedora-release`" -ge "15" ]; then
			echo
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
			echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
			echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Start:		systemctl start openresty				\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo

		else
			echo
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m #	The successful completion of the build.		#\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Version:		$OPENRESTY_VER				\033[0m \n"
			echo -ne "\033[33m  Binary:		$OPENRESTY_SBIN_PATH			\033[0m \n"
			echo -ne "\033[33m  Config files:		$OPENRESTY_PREFIX/nginx	\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo -ne "\033[33m  Start:		service openresty start				\033[0m \n"
			echo -ne "\033[33m ########################################################\033[0m \n"
			echo
		fi
else
	echo -ne "\033[31m- Main: Does not support that linux distributions from scripts.\033[0m \n"
	exit 0
fi

# Initializes for variables
unset DEBIAN REDHAT SCRIPTS_URL INIT_D_PATH SYSTEMD_PATH GOOGLE_PAGESPEED PSOL OPENRESTY_VER OPENRESTY_PREFIX \
OPENRESTY_UGID OPENRESTY_SBIN_PATH OPENRESTY_LOCK_PATH OPENRESTY_PID_PATH OPENRESTY_ERROR_LOGS
