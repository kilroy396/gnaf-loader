CREATE UNIQUE INDEX address_default_geocode_pid_idx ON dbo.address_default_geocode (address_detail_pid);
--CREATE UNIQUE INDEX address_mesh_block_2011_pid_idx ON dbo.address_mesh_block_2011 (address_detail_pid);
CREATE UNIQUE INDEX address_mesh_block_2016_pid_idx ON dbo.address_mesh_block_2016 (address_detail_pid);
CREATE UNIQUE INDEX address_mesh_block_2021_pid_idx ON dbo.address_mesh_block_2021 (address_detail_pid);
CREATE INDEX street_locality_loc_pid_idx ON dbo.street_locality (locality_pid);
--CREATE UNIQUE INDEX mb_2011_pid_idx ON dbo.mb_2011 (mb_2011_pid);
CREATE UNIQUE INDEX mb_2016_pid_idx ON dbo.mb_2016 (mb_2016_pid);
CREATE UNIQUE INDEX mb_2021_pid_idx ON dbo.mb_2021 (mb_2021_pid);
