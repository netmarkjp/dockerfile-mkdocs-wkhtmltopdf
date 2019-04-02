FROM centos:7.6.1810
MAINTAINER Toshiaki Baba<toshiaki@netmark.jp>

RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock \
      && echo 'UTC=false' >> /etc/sysconfig/clock \
      && yum -y install tzdata && yum clean all \
      && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN yum -y install \
        epel-release \
        https://centos7.iuscommunity.org/ius-release.rpm \
        && yum clean all
RUN yum -y install \
        python36u \
        python36u-pip \
        git \
        zip \
        which \
        Xvfb \
        https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm \
        google-noto-sans-japanese-fonts \
        && yum clean all

RUN /usr/bin/pip3.6 install --upgrade pip wheel setuptools
RUN /usr/bin/pip3.6 install --upgrade pipenv

ENV PIPENV_VENV_IN_PROJECT true
COPY Pipfile      /root/Pipfile
COPY Pipfile.lock /root/Pipfile.lock
RUN cd /root && pipenv --python=/usr/bin/python3.6 sync

ENV PATH "/root/.venv/bin:/usr/local/bin:/usr/bin:$PATH"

COPY build.sh /root/build.sh

EXPOSE 8000

WORKDIR /mnt
CMD ["/root/build.sh"]
