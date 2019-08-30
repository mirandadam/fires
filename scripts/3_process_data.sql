UPDATE intermediate.so_hybam_amazon_basin_area SET geom=ST_MakeValid(geom);
--Query returned successfully in 1 secs 400 msec.

UPDATE intermediate.ibge_bc250_amazon_municipalities_simplified SET geom=ST_CollectionExtract(ST_MakeValid(geom),3);


SELECT EXTRACT(DOY FROM DATE '2019-08-27');
--Last data comes from the 239th day of the year

DROP TABLE IF EXISTS intermediate.nasa_firm;
CREATE TABLE intermediate.nasa_firm
(
    gid serial PRIMARY KEY,
    acq_date date,
    acq_time character varying(4),
    instrument character varying(5),
    version character varying(6),
    geom geometry(Point,4326)
);

INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4545;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4547;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4549;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4551;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4555;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_m6_4557;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_v1_4546;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_v1_4548;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_v1_4550;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_v1_4552;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_archive_v1_4556;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_nrt_m6_4545;
INSERT INTO intermediate.nasa_firm (acq_date,acq_time,instrument,version,geom) SELECT acq_date, acq_time, instrument, version, geom FROM inputs.firm_nrt_v1_4546;
--Query returned successfully in 9 min 55 secs.

CREATE INDEX ON intermediate.nasa_firm USING gist(geom);
--Query returned successfully in 49 min 58 secs.
CREATE INDEX ON intermediate.nasa_firm(acq_date);
--Query returned successfully in 1 min 54 secs.

CREATE INDEX ON intermediate.nasa_firm(instrument);
--Query returned successfully in 1 min 58 secs.

--add doy column, populate it and index it




DROP TABLE IF EXISTS intermediate.nasa_firm2;
CREATE TABLE intermediate.nasa_firm2
(
    gid integer,
    acq_date date,
    acq_year integer,
    acq_doy  integer,
    instrument character varying(5),
    version character varying(6),
    geom geometry(Point,4326)
);

INSERT INTO intermediate.nasa_firm2 (gid, acq_date, acq_year, acq_doy, instrument, version, geom)
SELECT 
  gid,
  acq_date,
  EXTRACT(YEAR FROM acq_date),
  EXTRACT(DOY FROM acq_date),
  instrument,
  version,
  geom
FROM
  intermediate.nasa_firm
;

--INSERT 0 109991750
--Query returned successfully in 12 min 3 secs.

ALTER TABLE intermediate.nasa_firm2 ADD PRIMARY KEY (gid);
--Query returned successfully in 5 min 24 secs.
CREATE INDEX ON intermediate.nasa_firm2(acq_year);
--Query returned successfully in 4 min 29 secs.
CREATE INDEX ON intermediate.nasa_firm2(acq_doy);
--Query returned successfully in 4 min 32 secs.
CREATE INDEX ON intermediate.nasa_firm2(acq_date);
--Query returned successfully in 4 min 25 secs.
CREATE INDEX ON intermediate.nasa_firm2(instrument);
--Query returned successfully in 4 min 26 secs.
CREATE INDEX ON intermediate.nasa_firm2 USING gist(geom);
--Query returned successfully in 1 hr.


DROP MATERIALIZED VIEW outputs.amazon_area_by_country;
CREATE MATERIALIZED VIEW outputs.amazon_area_by_country AS
SELECT
    t2.id,
    t2.geounit AS "Country",
    ST_Area(ST_Intersection(t1.geom,t2.geom)::geography)/(1000000) AS "Area km2"
FROM 
    intermediate.so_hybam_amazon_basin_area as t1,
    inputs.natural_earth_countries as t2
WHERE
    ST_Intersects(t1.geom,t2.geom)
;
--Query returned successfully in 207 msec.
CREATE INDEX ON outputs.amazon_area_by_country(id);



CREATE MATERIALIZED VIEW outputs.area_by_country AS
SELECT
    t2.id,
    t2.geounit AS "Country",
    ST_Area(t2.geom::geography)/(1000000) AS "Area km2"
FROM 
    inputs.natural_earth_countries as t2
;
CREATE INDEX ON outputs.area_by_country(id);


--DROP MATERIALIZED VIEW outputs.modis_amazon_fires_by_country;
CREATE MATERIALIZED VIEW outputs.modis_amazon_fires_by_country AS
SELECT
    t3.id,
    t3.geounit AS "Country",
    count(1) AS "MODIS Fires",
    1000*count(1)/t4."Area km2" AS "MODIS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='MODIS'
    AND t4.id=t3.id
GROUP BY
    t1.acq_year,
    t3.id,
    t3.geounit,
    t4.id,
    t4."Area km2"
;
--Query returned successfully in ~2min


--DROP MATERIALIZED VIEW outputs.modis_amazon_fires_by_country_until_aug_27;
CREATE MATERIALIZED VIEW outputs.modis_amazon_fires_by_country_until_aug_27 AS
SELECT
    t3.id,
    t3.geounit AS "Country",
    count(1) AS "MODIS Fires",
    1000*count(1)/t4."Area km2" AS "MODIS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='MODIS'
    AND t4.id=t3.id
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t3.id,
    t3.geounit,
    t4.id,
    t4."Area km2"
;
--Query returned successfully in 1 min 13 secs.


--DROP MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country;
CREATE MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country AS
SELECT
    t3.id,
    t3.geounit AS "Country",
    count(1) AS "VIIRS Fires",
    1000*count(1)/t4."Area km2" AS "VIIRS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='VIIRS'
    AND t4.id=t3.id
GROUP BY
    t1.acq_year,
    t3.id,
    t3.geounit,
    t4.id,
    t4."Area km2"
;
--Query returned successfully in 6 min 23 secs.


--DROP MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country_until_aug_27;
CREATE MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country_until_aug_27 AS
SELECT
    t3.id,
    t3.geounit AS "Country",
    count(1) AS "VIIRS Fires",
    1000*count(1)/t4."Area km2" AS "VIIRS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='VIIRS'
    AND t4.id=t3.id
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t3.id,
    t3.geounit,
    t4.id,
    t4."Area km2"
;
--Query returned successfully in 3 min 37 secs.

DROP MATERIALIZED VIEW outputs.modis_amazon_fires_by_state_until_aug_27;
CREATE MATERIALIZED VIEW outputs.modis_amazon_fires_by_state_until_aug_27 AS
SELECT
    t2.nome AS "State",
    count(1) AS "MODIS Fires",
    1000*1000000*count(1)/ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography) AS "MODIS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.ibge_brazil_states_simplified as t2,
    intermediate.so_hybam_amazon_basin_area as t3
WHERE
    ST_Contains(ST_SetSRID(t2.geom,4326), t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.instrument='MODIS'
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t2.nome,
    t2.geom,
    t3.geom
;
--Query returned successfully in 3 min 37 secs.

--DROP MATERIALIZED VIEW outputs.viirs_amazon_fires_by_state_until_aug_27;
CREATE MATERIALIZED VIEW outputs.viirs_amazon_fires_by_state_until_aug_27 AS
SELECT
    t2.nome AS "State",
    count(1) AS "VIIRS Fires",
    1000*1000000*count(1)/ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography) AS "VIIRS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.ibge_brazil_states_simplified as t2,
    intermediate.so_hybam_amazon_basin_area as t3
WHERE
    ST_Contains(ST_SetSRID(t2.geom,4326), t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.instrument='VIIRS'
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t2.nome,
    t2.geom,
    t3.geom
;
--Query returned successfully in 3 min 22 secs.


--DROP MATERIALIZED VIEW outputs.modis_fires_by_country;
CREATE MATERIALIZED VIEW outputs.modis_fires_by_country AS
SELECT
    t2.id,
    t2.geounit AS "Country",
    count(1) AS "MODIS Fires",
    1000*count(1)/t3."Area km2" AS "MODIS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    inputs.natural_earth_countries as t2,
    outputs.area_by_country as t3
WHERE
    ST_Contains(t2.geom, t1.geom)
    AND t1.instrument='MODIS'
    AND t1.acq_date > '2016-01-01'
    AND t3.id=t2.id
GROUP BY
    t1.acq_year,
    t2.id,
    t2.geounit,
    t2.geom,
    t3."Area km2"
;
--Query returned successfully in 59 min 53 secs.


--DROP MATERIALIZED VIEW outputs.VIIRS_fires_by_country;
CREATE MATERIALIZED VIEW outputs.VIIRS_fires_by_country AS
SELECT
    t2.id,
    t2.geounit AS "Country",
    count(1) AS "VIIRS Fires",
    1000*count(1)/t3."Area km2" AS "VIIRS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    inputs.natural_earth_countries as t2,
    outputs.area_by_country as t3
WHERE
    ST_Contains(t2.geom, t1.geom)
    AND t1.instrument='VIIRS'
    AND t1.acq_date > '2016-01-01'
    AND t3.id=t2.id
GROUP BY
    t1.acq_year,
    t2.id,
    t2.geounit,
    t2.geom,
    t3."Area km2"
;
--"Query returned successfully in 3 hr 22 min", but the table was not created and it apparently used all the available disk space before failing (133GB).



DROP MATERIALIZED VIEW outputs.modis_amazon_fires_by_municipality_until_aug_27;
CREATE MATERIALIZED VIEW outputs.modis_amazon_fires_by_municipality_until_aug_27 AS
SELECT
    t2.geocodigo AS id,
    t2.nome AS "Municipality",
    ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography)/1000000 AS "Area km2",
    count(1) AS "MODIS Fires",
    1000*1000000*count(1)/ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography) AS "MODIS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.ibge_bc250_amazon_municipalities_simplified as t2,
    intermediate.so_hybam_amazon_basin_area as t3
WHERE
    ST_Contains(ST_SetSRID(t2.geom,4326), t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.instrument='MODIS'
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t2.geocodigo,
    t2.nome,
    t2.geom,
    t3.geom
;
--Query returned successfully in 4 min 46 secs.


DROP MATERIALIZED VIEW outputs.viirs_amazon_fires_by_municipality_until_aug_27;
CREATE MATERIALIZED VIEW outputs.viirs_amazon_fires_by_municipality_until_aug_27 AS
SELECT
    t2.geocodigo AS id,
    t2.nome AS "Municipality",
    ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography)/1000000 AS "Area km2",
    count(1) AS "VIIRS Fires",
    1000*1000000*count(1)/ST_Area(ST_Intersection(t3.geom, ST_SetSRID(t2.geom,4326))::geography) AS "VIIRS Fires per 1000km2",
    t1.acq_year AS "Year"
FROM
    intermediate.nasa_firm2 as t1,
    intermediate.ibge_bc250_amazon_municipalities_simplified as t2,
    intermediate.so_hybam_amazon_basin_area as t3
WHERE
    ST_Contains(ST_SetSRID(t2.geom,4326), t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.instrument='VIIRS'
    AND t1.acq_doy<=239
GROUP BY
    t1.acq_year,
    t2.geocodigo,
    t2.nome,
    t2.geom,
    t3.geom
;
--Query returned successfully in 4 min 2 secs.










----obsoletes------
SELECT EXTRACT(DOY FROM DATE '2019-08-27');
--239th day of the year do ano

DROP MATERIALIZED VIEW outputs.modis_amazon_fires_by_country_until_aug_27;
CREATE MATERIALIZED VIEW outputs.modis_amazon_fires_by_country_until_aug_27 AS
SELECT
    t3.geounit AS "Country",
    count(1) AS "MODIS Fires",
    count(1)/t4."Area km2" AS "MODIS Fires per km2",
    EXTRACT(YEAR FROM t1.acq_date) AS "Year"
FROM
    intermediate.nasa_firm as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='MODIS'
    AND t4."Country"=t3.geounit
    AND EXTRACT(DOY FROM t1.acq_date)<=239
GROUP BY
    EXTRACT(YEAR FROM t1.acq_date),
    t3.geounit,
    t4."Country",
    t4."Area km2"
;
--Query returned successfully in 2 min 38 secs.



DROP MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country_until_aug_27;
CREATE MATERIALIZED VIEW outputs.viirs_amazon_fires_by_country_until_aug_27 AS
SELECT
    t3.geounit AS "Country",
    count(1) AS "VIIRS Fires",
    count(1)/t4."Area km2" AS "VIIRS Fires per km2",
    EXTRACT(YEAR FROM t1.acq_date) AS "Year"
FROM
    intermediate.nasa_firm as t1,
    intermediate.so_hybam_amazon_basin_area as t2,
    inputs.natural_earth_countries as t3,
    outputs.amazon_area_by_country as t4
WHERE
    ST_Contains(t2.geom,t1.geom)
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.acq_date>'2016-01-01'
    AND t1.instrument='VIIRS'
    AND t4."Country"=t3.geounit
    AND EXTRACT(DOY FROM t1.acq_date)<=239
GROUP BY
    EXTRACT(YEAR FROM t1.acq_date),
    t3.geounit,
    t4."Country",
    t4."Area km2"
;
--Query returned successfully in 5 min 28 secs.


DROP MATERIALIZED VIEW outputs.modis_fires_by_country_until_aug_27;
CREATE MATERIALIZED VIEW outputs.modis_fires_by_country_until_aug_27 AS
SELECT
    t3.id AS id,
    t3.geounit AS "Country",
    count(1) AS "MODIS Fires",
    EXTRACT(YEAR FROM t1.acq_date) AS "Year"
FROM
    intermediate.nasa_firm as t1,
    inputs.natural_earth_countries as t3
WHERE
    t3.geounit = 'France'
    AND ST_Contains(t3.geom, t1.geom)
    AND t1.instrument='MODIS'
    AND t1.acq_date>'2016-01-01'
    AND EXTRACT(DOY FROM t1.acq_date)<=239

GROUP BY
    EXTRACT(YEAR FROM t1.acq_date),
    t3.id,
    t3.geounit
;
--Query returned successfully in 4 min 40 secs.
