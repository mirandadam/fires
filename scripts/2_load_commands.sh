echo temp/fire_archive_M6_4545.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4545.shp inputs.firm_archive_M6_4545 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_nrt_M6_4545.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_nrt_M6_4545.shp inputs.firm_nrt_M6_4545 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_nrt_V1_4546.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_nrt_V1_4546.shp inputs.firm_nrt_V1_4546 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_V1_4546.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_V1_4546.shp inputs.firm_archive_V1_4546 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_M6_4547.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4547.shp inputs.firm_archive_M6_4547 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_V1_4548.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_V1_4548.shp inputs.firm_archive_V1_4548 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_M6_4549.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4549.shp inputs.firm_archive_M6_4549 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_V1_4550.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_V1_4550.shp inputs.firm_archive_V1_4550 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_M6_4551.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4551.shp inputs.firm_archive_M6_4551 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_V1_4552.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_V1_4552.shp inputs.firm_archive_V1_4552 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_M6_4555.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4555.shp inputs.firm_archive_M6_4555 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_V1_4556.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_V1_4556.shp inputs.firm_archive_V1_4556 | psql -d fires -U postgres -h 127.0.0.1
echo temp/fire_archive_M6_4557.shp
shp2pgsql -d -D -g geom -s "EPGS:4326" temp/fire_archive_M6_4557.shp inputs.firm_archive_M6_4557 | psql -d fires -U postgres -h 127.0.0.1
