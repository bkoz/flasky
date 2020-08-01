FROM registry.access.redhat.com/ubi8/ubi
MAINTAINER Bob Kozdemba <bkozdemba@gmail.com>

ENV FLASK_APP flasky.py
ENV FLASK_CONFIG production

# RUN adduser -D flasky
# USER flasky

# WORKDIR /home/flasky

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
RUN mkdir -p ${APP_ROOT}/{bin,src} && \
    chmod -R u+x ${APP_ROOT}/bin && chgrp -R 0 ${APP_ROOT} && chmod -R g=u ${APP_ROOT}
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

RUN yum -y install python3 && yum clean all -y

### Containers should NOT run as root as a good practice
USER 1001
# USER 0
WORKDIR ${APP_ROOT}

COPY requirements requirements
RUN python3 -m venv venv
RUN venv/bin/pip install -r requirements/docker.txt

COPY app app
COPY migrations migrations
COPY flasky.py config.py boot.sh ./

# run-time configuration
EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
