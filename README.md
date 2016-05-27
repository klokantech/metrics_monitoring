Build container with:
`docker build -t monitor .`

Run container with:
`docker run -d -p 3000:3000 -p 8083:8083 -p 8086:8086 -v /tmp/influxdb:/data -v /tmp/grafana:/var/lib/grafana --name monitor monitor`

port 3000 - Grafana
port 8083 - InfluxDb admin
port 8086 - InfluxDb queries

Login to Grafana with admin@admin

Grafana storage is already configured to local InfluxDb.

The most common element in Grafana dashboard is Graph panel and can be created with this guide:
http://docs.grafana.org/reference/graph/

Whole grafana dashboard can be exported into `json` file and next it can imported from `/var/lib/grafana/dashboards/` in another grafana instance.
http://docs.grafana.org/reference/export_import/

Write queries to InfluxDb can be done like:
`curl -i -XPOST 'http://localhost:8086/write?db=test' --data-binary 'metrics,tag_name1=tag_value1,tag_name2=tag_value2 value=0.78'`

Where:
`db=test` is InfluxDb database setting - `test` DB is already created
`metrics` is name of metrics (table name in SQL)
`tag_name1` and `tag_name2` are names of tags (names of indexed columns in SQL)
`tag_value1` and `tag_value2` are values of tags (values in indexed columns in SQL)
`value` name of value (names of non indexed columns in SQL)
`0.78` is value (values in non indexed columns in SQL)

https://docs.influxdata.com/influxdb/v0.12/write_protocols/write_syntax/

docker-compose.yml - for local testing with cadvisor
