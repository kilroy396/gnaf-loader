FROM python:3.9-slim-buster
# FROM debian:buster-slim

# Postgres user password - WARNING: change this to something more secure
ARG pg_password="password"
ENV PGPASSWORD=${pg_password}

# get postgres signing key, add Postgres repo to apt and install Postgres with PostGIS
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo wget gnupg2 \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | sudo tee  /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends postgresql-13 postgresql-client-13 postgis postgresql-13-postgis-3 \
    && apt-get autoremove -y --purge \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# start Postgres server and set the default user password. WARNING: insecure password
# TODO: create a unique, secure password at build time (if possible/practical?)
RUN /etc/init.d/postgresql start \
    && sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${pg_password}';"
    && sudo -u postgres psql -c "CREATE EXTENSION postgis;"

# download and restore GNAF & Admin Boundary Postgres dump files
RUN mkdir -p /data \
    && cd /data \
    && wget --quiet http://minus34.com/opendata/psma-202102/gnaf-202102.dmp \
    && wget --quiet http://minus34.com/opendata/psma-202102/admin-bdys-202102.dmp \
    && /etc/init.d/postgresql start \
    && pg_restore -Fc -d postgres -h localhost -p 5432 -U postgres /data/gnaf-202102.dmp \
    && pg_restore -Fc -d postgres -h localhost -p 5432 -U postgres /data/admin-bdys-202102.dmp \
    && rm /data/gnaf-202102.dmp \
    && rm /data/admin-bdys-202102.dmp

# enable external access to postgres - WARNING: these are insecure settings! Edit these to restrict access
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/13/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/13/main/postgresql.conf
EXPOSE 5432

# # Add VOLUMEs to allow backup of config, logs and databases
# VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# # This results in a single layer image
# FROM scratch

# Start postgres when starting a container
CMD ["/usr/lib/postgresql/13/bin/postgres", "-D", "/var/lib/postgresql/13/main", "-c", "config_file=/etc/postgresql/13/main/postgresql.conf"]
