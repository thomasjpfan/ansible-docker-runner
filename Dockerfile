FROM docker:17.12.0-ce

ENV ANSIBLE_VERSION 2.4.2.0
ENV TESTINFRA_VERSION 1.10.1
ENV ANSIBLE_LINT_VERSION 3.4.20

RUN apk --update add sudo && \
    apk --update add python py-pip openssl ca-certificates && \
    apk --update add --virtual build-dependencies \
    python-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi && \
    pip install ansible==${ANSIBLE_VERSION} \
    testinfra==${TESTINFRA_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION} && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/ansible/roles/role_to_test

COPY entrypoint.sh /usr/local/bin

WORKDIR /etc/ansible/roles/role_to_test

ENTRYPOINT ["entrypoint.sh"]
