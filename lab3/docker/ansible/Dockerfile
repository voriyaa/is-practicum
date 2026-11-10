FROM python:3.13.17-slim-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir ansible-core==2.22.0

WORKDIR /ansible
CMD ["sleep", "infinity"]
