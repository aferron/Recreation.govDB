create table Activities(
    ActivityID integer not null,
    ActivityParentID integer,
    ActivityName varchar(200),
    ActivityLevel integer,
    primary key (ActivityID)
)



create table CampsiteAttributes(
    AttributeID integer not null,
    AttributeName varchar(200),
    AttributeValue varchar(200),
    EntityID bigint,
    EntityType varchar(200),
    primary key (AttributeID, EntityID)
);



CREATE TABLE Campsites(
    CampsiteID bigint,
    FacilityID bigint,
    CampsiteName varchar(200),
    CampsiteType varchar(200),
    TypeOfUse varchar(200),
    Loop varchar(200),
    CampsiteAccessible boolean,
    CampsiteLongitude real,
    CampsiteLatitude real,
    CreatedDate date,
    LastUpdatedDate date,
    primary key(CampsiteID)
);



-- set the facilityID column in campsites to match the data type in facilities table
alter table w21adb31.campsites
alter column facilityid
set data type varchar(200);

-- set the facilityID column in facilityaddresses to match type in facilities
alter table w21adb31.facilityaddresses
alter column facilityid
set data type varchar(200);

-- check that all campsite facilityIDs are in the facilities table
select facilityid
from w21adb31.campsites
where facilityid not in(
    select facilityid
    from w21adb31.facilities
);



create table EntityActivities(
    ActivityID integer not null references Activities(ActivityID),
    ActivityDescription varchar(2000),
    ActivityFeeDescription varchar(200),
    EntityID integer,
    EntityType varchar(100),
    primary key (ActivityID, EntityID)
);



create table Facilities(
    FacilityID varchar(200) not null,
    LegacyFacilityID varchar(200),
    OrgFacilityID varchar(200),
    ParentOrgID varchar(100),
    ParentRecAreaID integer,
    FacilityName varchar(200),
    FacilityDescription varchar(20000),
    FacilityTypeDescription varchar(200),
    FacilityUseFeeDescription varchar(2000),
    FacilityDirections varchar(20000),
    FacilityPhone varchar(1000),
    FacilityEmail varchar(100),
    FacilityReservationURL varchar(200),
    FacilityMapURL varchar(2000),
    FacilityAdaAccess varchar(2000),
    FacilityLongitude real,
    FacilityLatitude real,
    Keywords varchar(600),
    StayLimit varchar(1000),
    Reservable boolean,
    Enabled boolean,
    LastUpdatedDate date,
    primary key (facilityid)
);


-- alter table facilities
-- alter StayLimit type varchar(20);

-- alter table facilities
-- alter FacilityAdaAccess type varchar(2000);

-- alter table facilities
-- alter FacilityUseFeeDescription type varchar(2000);

-- alter table facilities
-- alter StayLimit type varchar(1000);

-- alter table facilities
-- alter FacilityEmail type varchar(100);

-- alter table facilities
-- alter FacilityPhone type varchar(1000);

-- alter table facilities
-- alter LegacyFacilityID type varchar(100);

-- alter table facilities
-- alter ParentOrgID type varchar(100);

-- alter table facilities
-- alter Keywords type varchar(600);

-- alter table facilities
-- alter facilitymapurl type varchar(2000);



create table FacilityAddresses(
    FacilityAddressID varchar(200),
    FacilityID integer,
    FacilityAddressType varchar(200),
    FacilityStreetAddress1 varchar(500),
    FacilityStreetAddress2 varchar(500),
    FacilityStreetAddress3 varchar(500),
    City varchar(50),
    PostalCode varchar(20),
    AddressStateCode varchar(20),
    AddressCountryCode varchar(40),
    LastUpdatedDate date,
    primary key (FacilityAddressID)
);



create table Links(
    LinkID varchar(200) not null,
    LinkType varchar(100),
    EntityID integer,
    EntityType varchar(100),
    Title varchar(400),
    Description varchar(3200),
    URL varchar(400),
    primary key (LinkID, EntityID)
)



create table Organizations(
    OrgID integer not null,
    OrgType varchar(100),
    OrgName varchar(200),
    OrgImageUrl varchar(100),
    OrgUrlText varchar(2000),
    OrgUrlAddress varchar(200),
    OrgAbbrevName varchar(20),
    OrgJurisdictionType varchar(20),
    OrgParentID integer,
    LastUpdatedDate date,
    primary key (OrgID)
)



create table OrgEntities(
    EntityID varchar(200) not null,
    -- OrgID should reference Organizations(OrgID), 
    -- but not all values present in that table
    OrgID integer,
    EntityType varchar(40),
    primary key (EntityID)
);



create table PermitEntranceAttributes(
    AttributeID integer not null,
    AttributeName varchar(100),
    AttributeValue varchar(4000),
    EntityID integer,
    EntityType varchar(100),
    primary key (AttributeID, EntityID)
);



-- Created PermitEntrances table,
-- cleaned data to allow foreign key constraint for facilities
create table PermitEntrances(
    PermitEntranceID integer not null,
    PermitEntranceType varchar(200),
    -- Foreign key constraint doesnt work because not all ids present in facilities table
    -- FacilityID varchar(200) references Facilities(FacilityID),
    -- Foreign key constraint added below
    FacilityID varchar(200),
    PermitEntranceName varchar(100),
    PermitEntranceDescription varchar(2000),
    District varchar(200),
    Town varchar(100),
    PermitEntranceAccessible boolean,
    Longitude real,
    Latitute real,
    CreatedDate date,
    LastUpdated date,
    primary key (PermitEntranceID)
);

-- Checking that facilityID's are all in the Facilities table
select facilityid
from facilities
where orgfacilityid in(
select facilityid from w21adb31.permitentrances
where facilityid not in(
    select facilityid from facilities
));

-- Adding missing IDs to Facilities table
insert into facilities (facilityid)
select distinct facilityid as fID from w21adb31.permitentrances
where facilityid not in(
    select facilityid from facilities
);

-- Adding the foreign key to PermitEntrances table
alter table w21adb31.permitentrances
add foreign key (FacilityID) references Facilities(facilityid);



create table PermitEntranceZones(
    PermitEntranceZoneID integer not null,
    PermitEntranceID integer,
    Zone varchar(200),
    primary key (PermitEntranceZoneID)
);



create table PermittedEquipment(
    CampsiteID bigint not null,
    MaxLength real,
    EquipmentName varchar(100),
    primary key (CampsiteID, EquipmentName)
);



create table RecAreaAddresses(
    RecAreaAddressID bigint not null,
    RecAreaID bigint,
    RecAreaAddressType varchar(20),
    RecAreaStreetAddress1 varchar(200),
    RecAreaStreetAddress2 varchar(200),
    RecAreaStreetAddress3 varchar(200),
    City varchar(100),
    PostalCode varchar(20),
    AddressStateCode varchar(20),
    AddressCountryCode varchar(20),
    LastUpdated date,
    primary key (RecAreaAddressID)
);



create table RecAreaFacilities(
    RecAreaID bigint not null,
    FacilityID varchar(200) not null,
    primary key (RecAreaID, FacilityID)
);



create table RecAreas(
    RecAreaID varchar(200) not null,
    OrgRecAreaID varchar(200),
    ParentOrgID integer references Organizations(OrgID),
    RecAreaName varchar(200),
    RecAreaDescription varchar(8000),
    RecAreaUseFeeDescription varchar(200),
    RecAreaDirections varchar(4000),
    RecAreaPhone varchar(400),
    RecAreaEmail varchar(200),
    RecAreaReservationUrl varchar(400),
    RecAreaMapUrl varchar(400),
    RecAreaLongitute real,
    RecAreaLatitude real,
    StayLimit varchar(800),
    Keywords varchar(1000),
    Reservable boolean,
    Enabled boolean,
    LastUpdatedDate date,
    primary key (RecAreaID)
);



create table TourAttributes(
    AttributeID integer not null,
    AttributeName varchar(200),
    AttributeValue varchar(4000),
    EntityID varchar(200) not null,
    EntityType varchar(200),
    primary key (AttributeID, EntityID)
);



create table Tours(
    TourID bigint not null,
    -- FacilityID bigint references Facilities(FacilityID),
    -- try to add this foreign key
    FacilityID bigint not null,
    TourName varchar(1000),
    TourType varchar(200),
    TourDescription varchar(4000),
    TourDuration integer,
    TourAccessible boolean,
    CreatedDate date,
    LastUpdatedDate date,
    primary key (TourID)
);
