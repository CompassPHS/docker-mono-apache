FROM ubuntu:14.04

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list \
    && echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
    && apt-get update \
    && apt-get install mono-complete nuget libapache2-mod-mono mono-apache-server4 apache2 -y \
    && mkdir -p /etc/mono/registry \
    && chmod uog+rw /etc/mono/registry

COPY ./default.conf /etc/apache2/sites-available/default.conf

RUN rm /etc/apache2/sites-enabled/* \
    && ln -s /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/default.conf \
    && service apache2 restart

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
