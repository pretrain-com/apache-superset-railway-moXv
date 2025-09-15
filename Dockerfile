FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    pkg-config \
    libmariadb-dev \
    default-libmysqlclient-dev \
    build-essential \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install pip in the virtual environment and then install packages
RUN /app/.venv/bin/python3 -m ensurepip --upgrade && \
    /app/.venv/bin/python3 -m pip install --no-cache-dir mysqlclient psycopg2-binary psycopg2 

# Set environment variable to install additional packages (backup method)
ENV EXTRA_PIP_PACKAGES="mysqlclient psycopg2-binary psycopg2"

ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD
ENV DATABASE $DATABASE

COPY config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

COPY config/superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py
ENV SECRET_KEY $SECRET_KEY

USER superset

ENTRYPOINT [ "./superset_init.sh" ]
