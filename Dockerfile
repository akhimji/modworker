FROM centos:latest
RUN rpm -ivh "https://labs.consol.de/repo/stable/rhel7/i386/labs-consol-stable.rhel7.noarch.rpm"
RUN rpm -ivh "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
RUN yum install -y mod_gearman perl-Net* net-snmp net-snmp-utils perl-Net-SNMP which bc net-snmp-perl perl-Cache-Memcached.noarch perl-LWP-Protocol-https
ADD VMware-vSphere-CLI-5.1.0-780721.1.el6.x86_64.rpm  /tmp
ADD VMware-vSphere-Perl-SDK-5.1.0-780721.1.el6.x86_64.rpm /tmp
RUN yum localinstall -y /tmp/VMware*
RUN yum install -y ftp://mirror.switch.ch/pool/4/mirror/epel/7/x86_64/p/perl-Nagios-Plugin-0.36-7.el7.noarch.rpm
RUN rm -rf /tmp/VMware*
RUN VAR1=`PERL_LWP_SSL_VERIFY_HOSTNAME=0` && \
    export VAR1
ADD worker.conf /etc/mod_gearman/worker.conf
RUN mkdir -p /usr/lib64/nagios/plugins
ADD plugins.tar.gz /usr/lib64/nagios/plugins/
RUN useradd gearmand
RUN ["chown", "-R", "gearmand:gearmand", "/usr/lib64/nagios"]
RUN ["chown", "-R", "gearmand:gearmand", "/etc/mod_gearman"]
RUN ["chown", "-R", "gearmand:gearmand", "/usr/bin/mod_gearman_worker"]
RUN ["chmod", "777", "/usr/bin/mod_gearman_worker"]
USER geramand
CMD ["mod_gearman_worker", "--logmode=stdout", "--config=/etc/mod_gearman/worker.conf"]
