FROM docker:18.06.0-ce

LABEL version="1.1.0"

ENV ANSIBLE_VERSION 2.6.1
ENV TESTINFRA_VERSION 1.14.1
ENV ANSIBLE_LINT_VERSION 3.4.23

RUN apk --update add sudo python3 py3-pip openssl ca-certificates \
    openssh-client && \
    apk --update add --virtual build-dependencies \
    python3-dev libffi-dev openssl-dev build-base && \
    pip3 install --upgrade pip cffi && \
    pip3 install ansible==${ANSIBLE_VERSION} \
    testinfra==${TESTINFRA_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION} \
    pyOpenSSL && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/ansible/roles/role_to_test

COPY cli.sh /usr/local/bin/cli

WORKDIR /etc/ansible/roles/role_to_test

ENTRYPOINT [""]
