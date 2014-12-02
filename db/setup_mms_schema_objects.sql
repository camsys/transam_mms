
CREATE TABLE maintenance_activity_types  ( 
	id         	int(11) AUTO_INCREMENT NOT NULL,
	name       	varchar(64) NULL,
	description	varchar(254) NULL,
	active     	tinyint(1) NULL,
	PRIMARY KEY(id)
)
GO

CREATE TABLE maintenance_repeat_interval_types  ( 
	id         	int(11) AUTO_INCREMENT NOT NULL,
	name       	varchar(64) NULL,
	description	varchar(254) NULL,
	active     	tinyint(1) NULL,
	PRIMARY KEY(id)
)
GO

CREATE TABLE maintenance_service_interval_types  ( 
	id         	int(11) AUTO_INCREMENT NOT NULL,
	name       	varchar(64) NULL,
	description	varchar(254) NULL,
	active     	tinyint(1) NULL,
	PRIMARY KEY(id)
)
GO

CREATE TABLE maintenance_schedules  ( 
	id              	int(11) AUTO_INCREMENT NOT NULL,
	object_key      	varchar(12) NULL,
	organization_id 	int(11) NULL,
	asset_subtype_id	int(11) NULL,
	name            	varchar(64) NULL,
	description     	varchar(254) NULL,
	active          	tinyint(1) NULL,
	created_at          datetime NULL,
	updated_at          datetime NULL,
	PRIMARY KEY(id)
)
GO

CREATE INDEX maintenance_schedules_idx1 USING BTREE 
	ON maintenance_schedules(object_key)
GO

CREATE INDEX maintenance_schedules_idx2 USING BTREE 
	ON maintenance_schedules(organization_id, asset_subtype_id)
GO

CREATE TABLE maintenance_activities  ( 
	id                                      int(11) AUTO_INCREMENT NOT NULL,
	object_key                              varchar(12) NOT NULL,
	maintenance_schedule_id                 int(11) NOT NULL,
	maintenance_activity_type_id            int(11) NOT NULL,
	maintenance_service_interval_type_id    int(11) NOT NULL,
    maintenance_repeat_interval_type_id     int(11) NOT NULL,
    `interval`                              int(11) NOT NULL,
	required_by_manufacturer              	tinyint(1) NULL,
	active                                  tinyint(1) NULL,
	created_at                              datetime NULL,
	updated_at                              datetime NULL,
	PRIMARY KEY(id)
)
GO
CREATE INDEX maintenance_activities_idx1 USING BTREE 
	ON maintenance_activities(object_key)
GO
CREATE INDEX maintenance_activities_idx2 USING BTREE 
	ON maintenance_activities(maintenance_schedule_id)
GO
CREATE INDEX maintenance_activities_idx3 USING BTREE 
	ON maintenance_activities(maintenance_activity_type_id)
GO

CREATE TABLE maintenance_events  ( 
	id                     	int(11) AUTO_INCREMENT NOT NULL,
	object_key             	varchar(12) NULL,
	asset_id               	int(11) NULL,
	maintenance_provider_id	int(11) NULL,
    maintenance_service_order_id int(11) NULL,
	maintenance_activity_id	int(11) NULL,
    due_date                date NULL,
	event_date             	date NULL,
	parts_cost             	int(11) NULL,
	labor_cost             	int(11) NULL,
	completed_by_id        	int(11) NULL,
	miles_at_service       	int(11) NULL,
	created_at              datetime NULL,
	updated_at              datetime NULL,
	PRIMARY KEY(id)
)
GO

CREATE INDEX maintenance_event_idx1 USING BTREE 
	ON maintenance_events(object_key)
GO

CREATE INDEX maintenance_event_idx2 USING BTREE 
	ON maintenance_events(maintenance_provider_id)
GO
CREATE INDEX maintenance_event_idx3 USING BTREE 
	ON maintenance_events(asset_id, event_date)
GO

CREATE TABLE assets_maintenance_schedules  ( 
	asset_id               	int(11) NOT NULL,
	maintenance_schedule_id	int(11) NOT NULL 
	)
GO

CREATE INDEX assets_maintenance_schedules_idx1 USING BTREE 
	ON assets_maintenance_schedules(asset_id, maintenance_schedule_id)
GO

CREATE TABLE maintenance_providers  ( 
	id             	int(11) AUTO_INCREMENT NOT NULL,
	object_key     	varchar(12) NULL,
	organization_id	int(11) NULL,
    manager         varchar(64) NULL,
    email           varchar(128) NULL,
	name           	varchar(64) NULL,
	address1       	varchar(128) NULL,
	address2       	varchar(128) NULL,
	city           	varchar(64) NULL,
	state          	varchar(2) NULL,
	zip            	varchar(10) NULL,
	phone          	varchar(12) NULL,
	fax            	varchar(12) NULL,
	url            	varchar(128) NULL,
	latitude       	decimal(11,6) NULL,
	longitude      	decimal(11,6) NULL,
	active         	tinyint(1) NULL,
	created_at     	datetime NULL,
	updated_at     	datetime NULL,
	PRIMARY KEY(id)
)
GO
CREATE INDEX maintenance_providers_idx1 USING BTREE 
	ON maintenance_providers(object_key)
GO
CREATE INDEX maintenance_providers_idx2 USING BTREE 
	ON maintenance_providers(organization_id)
GO

CREATE TABLE assets_maintenance_providers  ( 
	asset_id               	int(11) NOT NULL,
	maintenance_provider_id	int(11) NOT NULL 
	)
GO
CREATE INDEX assets_maintenance_providers_idx1 USING BTREE 
	ON assets_maintenance_providers(asset_id, maintenance_provider_id)
GO

CREATE TABLE maintenance_service_orders  ( 
	id                     	int(11) AUTO_INCREMENT NOT NULL,
	object_key             	varchar(12) NOT NULL,
	workorder_number       	varchar(8) NULL,
	organization_id        	int(11) NOT NULL,
	asset_id               	int(11) NOT NULL,
	maintenance_provider_id	int(11) NOT NULL,
	order_date             	date NOT NULL,
	state                  	varchar(32) NOT NULL,
	created_at             	datetime NOT NULL,
	updated_at             	datetime NULL,
	PRIMARY KEY(id)
)
GO

-- maintenance_activity_types --
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(1, 'Oil Change/Filter/Lube', 'Oil Change / Filter / Lube', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(2, 'Tire Rotation/Balance', 'Rotate and check balance of tires.', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(3, 'Annual Certified Safety Inspection', 'Annual Certified Safety Inspection', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(4, 'ADA Wheelchair Ramp/Lift Service', 'ADA Wheelchair Ramp/Lift Service', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(5, 'Standard PM Inspection', 'Standard PM Inspection', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(6, 'Inspect automatic transmission fluid level', 'Inspect automatic transmission fluid level', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(7, 'Inspect brake systems', 'Inspect brake pads/shoes/rotors/drums, brake lines & hoses, & parking brake system', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(8, 'Inspect cooling system and hoses', 'Inspect cooling system and hoses', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(9, 'Replace fuel filter', 'Replace fuel filter', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(10, 'Lubrication', 'Inspect & lubricate all non-sealed steering linkage,ball joints,suspension joints,half and drive-shafts and u-joints', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(11, 'Inspect exhaust system', 'Inspect complete exhaust system and heat shields', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(12, 'Replace engine air filter', 'Inspect complete exhaust system and heat shields', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(13, 'Inspect wheel bearings', 'Inspect 4x2 front wheel bearings; replace grease and grease seals, and adjust bearings', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(14, 'Replace platinum-tipped spark plugs', 'Replace platinum-tipped spark plugs', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(15, 'Inspect accessory drive belt/s', 'Inspect accessory drive belt/s', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(16, 'Change Premium Gold engine coolant', 'Change Premium Gold engine coolant', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(17, 'Replace rear axle lubricant', 'Replace rear axle lubricant', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(18, 'Replace PCV valve', 'Replace PCV valve', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(19, 'Replace front wheel bearings', 'Replace front 4x2 whell bearings & grease seals, lubricate & adjust bearings', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(20, 'Replace accesory drive belts', 'Replace accesory drive belts (if not replaced within last 100,000)', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(21, 'Inspect/Replace Fire Extinguisher', 'Inspect/Replace Fire Extinguisher', 1)
GO
INSERT INTO maintenance_activity_types(id, name, description, active)
  VALUES(22, 'Inspect/Replace passenger compartment air filter', 'Inspect and replace passenger compartment air filter', 1)
GO

-- maintenance_repeat_interval_types --
INSERT INTO maintenance_repeat_interval_types(id, name, description, active)
  VALUES(1, 'every', 'Activity must be performed repeatedly.', 1)
GO
INSERT INTO maintenance_repeat_interval_types(id, name, description, active)
  VALUES(2, 'at', 'Activity must be performed at the specified point.', 1)
GO

-- maintenance_service_interval_types --
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(1, 'miles', 'miles travelled.', 1)
GO
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(2, 'hours', 'hours or operation.', 1)
GO
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(3, 'days', 'days between activities', 1)
GO
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(4, 'weeks', 'weeks between activities.', 1)
GO
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(5, 'months', 'months between activities', 1)
GO
INSERT INTO maintenance_service_interval_types(id, name, description, active)
  VALUES(6, 'years', 'years between activities', 1)
GO

