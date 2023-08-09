-- -- sample sql to get the table list from a schema
-- SELECT 'DROP TABLE IF EXISTS ' ||table_schema || '.' || table_name || ';'
--   FROM information_schema.tables
--   WHERE table_schema = 'dbo'
--   ORDER BY table_name;


-- raw gnaf tables

-- https://www.sqlines.com/sql-server/drop_references

-- SOLUTION: run it twice ;o)

DECLARE @database nvarchar(50)
set @database = 'GNAF'

DROP TABLE IF EXISTS dbo.ADDRESS_ALIAS;
DROP TABLE IF EXISTS dbo.street_locality_point;
DROP TABLE IF EXISTS dbo.primary_secondary;
DROP TABLE IF EXISTS dbo.address_site_geocode;
DROP TABLE IF EXISTS dbo.locality_alias;
DROP TABLE IF EXISTS dbo.locality_point;
--DROP TABLE IF EXISTS dbo.address_mesh_block_2011;
DROP TABLE IF EXISTS dbo.address_mesh_block_2016;
DROP TABLE IF EXISTS dbo.address_alias;
DROP TABLE IF EXISTS dbo.locality_neighbour;
DROP TABLE IF EXISTS dbo.address_default_geocode;
DROP TABLE IF EXISTS dbo.street_locality_alias;

-- t-sql scriptlet to drop all constraints on a table

DECLARE @table nvarchar(50)
set @table = 'dbo.address_detail'

DECLARE @sql nvarchar(255)
WHILE EXISTS(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where constraint_catalog = @database and table_name = @table)
BEGIN
    select    @sql = 'ALTER TABLE ' + @table + ' DROP CONSTRAINT ' + CONSTRAINT_NAME 
    from    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where    constraint_catalog = @database and 
            table_name = @table
    exec    sp_executesql @sql
END

DROP TABLE IF EXISTS dbo.address_detail;
DROP TABLE IF EXISTS dbo.mb_match_code_aut;
--DROP TABLE IF EXISTS dbo.mb_2011;
DROP TABLE IF EXISTS dbo.mb_2016;
DROP TABLE IF EXISTS dbo.street_locality_alias_type_aut;
DROP TABLE IF EXISTS dbo.locality_alias_type_aut;
DROP TABLE IF EXISTS dbo.geocode_type_aut;
DROP TABLE IF EXISTS dbo.address_alias_type_aut;
DROP TABLE IF EXISTS dbo.ps_join_type_aut;
DROP TABLE IF EXISTS dbo.geocoded_level_type_aut;
DROP TABLE IF EXISTS dbo.street_locality;
DROP TABLE IF EXISTS dbo.address_site;
DROP TABLE IF EXISTS dbo.level_type_aut;
DROP TABLE IF EXISTS dbo.flat_type_aut;
DROP TABLE IF EXISTS dbo.street_type_aut;
DROP TABLE IF EXISTS dbo.locality;
DROP TABLE IF EXISTS dbo.street_class_aut;
DROP TABLE IF EXISTS dbo.street_suffix_aut;
DROP TABLE IF EXISTS dbo.address_type_aut;
DROP TABLE IF EXISTS dbo.locality_class_aut;
DROP TABLE IF EXISTS dbo.state;
DROP TABLE IF EXISTS dbo.geocode_reliability_aut;
-- new for August 2018
DROP TABLE IF EXISTS dbo.address_feature;
DROP TABLE IF EXISTS dbo.address_change_type_aut;
-- new for August 2021
DROP TABLE IF EXISTS dbo.address_mesh_block_2021;
DROP TABLE IF EXISTS dbo.mb_2021;
DROP TABLE IF EXISTS dbo.locality_pid_linkage;
--DROP TABLE IF EXISTS dbo.locality_pid_linkage_distinct;

---- drop raw admin boundaries - bit of a who cares...
--DROP TABLE IF EXISTS raw_dbo.aus_comm_electoral;
--DROP TABLE IF EXISTS raw_dbo.aus_comm_electoral_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_gccsa_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_gccsa_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_iare_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_iare_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_iloc_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_iloc_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_ireg_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_ireg_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_lga;
--DROP TABLE IF EXISTS raw_dbo.aus_lga_locality;
--DROP TABLE IF EXISTS raw_dbo.aus_lga_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_locality;
--DROP TABLE IF EXISTS raw_dbo.aus_locality_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_locality_town;
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2016;
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2016_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_remoteness_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_remoteness_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sa1_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sa1_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sa2_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sa2_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sa3_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sa3_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sa4_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sa4_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_seifa_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sos_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sos_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sosr_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sosr_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_state;
--DROP TABLE IF EXISTS raw_dbo.aus_state_electoral;
--DROP TABLE IF EXISTS raw_dbo.aus_state_electoral_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_state_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_sua_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_sua_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_town;
--DROP TABLE IF EXISTS raw_dbo.aus_town_point;
--DROP TABLE IF EXISTS raw_dbo.aus_ucl_2011;
--DROP TABLE IF EXISTS raw_dbo.aus_ucl_2011_polygon;
--DROP TABLE IF EXISTS raw_dbo.aus_ward;
--DROP TABLE IF EXISTS raw_dbo.aus_ward_polygon;
---- new for August 2021
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2021;
--DROP TABLE IF EXISTS raw_dbo.aus_mb_2021_polygon;

-- drop reference gnaf
DROP TABLE IF EXISTS gnaf.address_alias_lookup;
DROP TABLE IF EXISTS gnaf.address_boundary_tags;
DROP TABLE IF EXISTS gnaf.address_secondary_lookup;
DROP TABLE IF EXISTS gnaf.address_principals;
DROP TABLE IF EXISTS gnaf.address_aliases;
DROP TABLE IF EXISTS gnaf.localities;
DROP TABLE IF EXISTS gnaf.locality_aliases;
DROP TABLE IF EXISTS gnaf.locality_neighbour_lookup;
DROP TABLE IF EXISTS gnaf.streets;

-- drop reference admin boundaries
DROP TABLE IF EXISTS dbo.commonwealth_electorates;
DROP TABLE IF EXISTS dbo.commonwealth_electorates_analysis;
DROP TABLE IF EXISTS dbo.local_government_areas;
DROP TABLE IF EXISTS dbo.local_government_areas_analysis;
DROP TABLE IF EXISTS dbo.local_government_wards;
DROP TABLE IF EXISTS dbo.local_government_wards_analysis;
DROP TABLE IF EXISTS dbo.locality_bdys;
DROP TABLE IF EXISTS dbo.locality_bdys_analysis;
DROP TABLE IF EXISTS dbo.postcode_bdys;
DROP TABLE IF EXISTS dbo.postcode_bdys_analysis;
DROP TABLE IF EXISTS dbo.state_bdys_analysis;
DROP TABLE IF EXISTS dbo.state_lower_house_electorates;
DROP TABLE IF EXISTS dbo.state_lower_house_electorates_analysis;
DROP TABLE IF EXISTS dbo.state_upper_house_electorates;
DROP TABLE IF EXISTS dbo.stateupper_house_electorates_analysis;

--DROP TABLE IF EXISTS dbo.abs_2011_gccsa;
--DROP TABLE IF EXISTS dbo.abs_2011_mb;
--DROP TABLE IF EXISTS dbo.abs_2011_sa1;
--DROP TABLE IF EXISTS dbo.abs_2011_sa2;
--DROP TABLE IF EXISTS dbo.abs_2011_sa3;
--DROP TABLE IF EXISTS dbo.abs_2011_sa4;

DROP TABLE IF EXISTS dbo.abs_2016_gccsa;
DROP TABLE IF EXISTS dbo.abs_2016_mb;
DROP TABLE IF EXISTS dbo.abs_2016_sa1;
DROP TABLE IF EXISTS dbo.abs_2016_sa2;
DROP TABLE IF EXISTS dbo.abs_2016_sa3;
DROP TABLE IF EXISTS dbo.abs_2016_sa4;

DROP TABLE IF EXISTS dbo.abs_2021_gccsa;
DROP TABLE IF EXISTS dbo.abs_2021_mb;
DROP TABLE IF EXISTS dbo.abs_2021_sa1;
DROP TABLE IF EXISTS dbo.abs_2021_sa2;
DROP TABLE IF EXISTS dbo.abs_2021_sa3;
DROP TABLE IF EXISTS dbo.abs_2021_sa4;
