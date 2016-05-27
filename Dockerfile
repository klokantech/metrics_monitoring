FROM debian:jessie

# Install dependencies and supervisord
RUN apt-get update && apt-get install -qq -y \
	adduser \
	libfontconfig \
	curl \
	python-pip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -q supervisor

# Install Grafana
ENV GRAFANA_VERSION 3.0.4-1464167696
RUN curl -s -o /tmp/grafana_amd64.deb https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
  dpkg -i /tmp/grafana_amd64.deb && \
  rm /tmp/grafana_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

# Install InfluxDB
ENV INFLUXDB_VERSION 0.12.1-1
RUN curl -s -o /tmp/influxdb_latest_amd64.deb https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
  dpkg -i /tmp/influxdb_latest_amd64.deb && \
  rm /tmp/influxdb_latest_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

# Copy config
ADD grafana/grafana.ini /etc/grafana/grafana.ini
ADD grafana/init.sh /init-grafana.sh
ADD influxdb/types.db /usr/share/collectd/types.db
ADD influxdb/config.toml /config/config.toml
ADD influxdb/run.sh /run.sh

# InfluxDB Admin server WebUI
EXPOSE 8083

# InfluxDB HTTP API
EXPOSE 8086

#Grafana port
EXPOSE 3000

COPY supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/var/lib/grafana", "/data"]

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
