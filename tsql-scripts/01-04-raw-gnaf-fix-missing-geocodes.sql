USE GNAF;
GO

-- SQLINES DEMO *** ssing default coordinates - 202305 release issue
-- SQLINES LICENSE FOR EVALUATION USE ONLY
with missing as (
    select address_detail_pid
    from dbo.address_default_geocode
    where latitude is null or longitude is null
), site as (
    select adr.address_detail_pid,
           adr.address_site_pid
    from dbo.address_detail as adr
    inner join missing on adr.address_detail_pid = missing.address_detail_pid
), coords as (
    select site.address_detail_pid,
           geo.latitude,
           geo.longitude
    from dbo.address_site_geocode as geo
    inner join site on geo.address_site_pid = site.address_site_pid
    where geocode_type_code = 'PAPS'
)
update dbo.address_default_geocode set
    latitude = coords.latitude,
    longitude = coords.longitude
from coords
where dbo.address_default_geocode.address_detail_pid = coords.address_detail_pid