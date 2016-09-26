FROM oviis/jenkins-dind-slave:v2
MAINTAINER Ovi Isai <ovidiu.isai@gmail.com>

USER root
RUN echo "===> Installing sudo to emulate normal OS behavior and other needed bins..."  && \
    apk --update add sudo gcc git curl                          && \
    \
    \
    echo "===> Adding Python runtime..."  && \
    \
    apk --update add python py-pip openssl ca-certificates gcc   && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base     && \
    echo "===> Adding needed dependencies..."  && \
    pip install --upgrade pip cffi awscli boto boto3 m2crypto    && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible==1.9.4         && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
echo 'localhost' > /etc/ansible/hosts


USER jenkins

ONBUILD  RUN  \
              echo "===> Diagnosis: host information..."  && \
              ansible -c local -m setup all

