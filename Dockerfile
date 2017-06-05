FROM docker:17.05.0-ce

RUN apk --update add python py-pip openssl ca-certificates && \
    apk --update add --virtual .build-deps \
                python-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi && \
    pip install ansible ansible-lint && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

# Remove entrypoint
ENTRYPOINT []
