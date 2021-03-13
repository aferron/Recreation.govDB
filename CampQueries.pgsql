-- 1. What are the campground names, addresses, latitude, longitude of campgrounds
--  with accessible campsites within the latitude and longitudes that generally 
-- bound Oregon and Washington? 

-- Change some datatypes in the tables to allow joins.
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

-- There are 7690 campsites within Oregon and Washington
select campsitelatitude, campsitelongitude
from w21adb31.campsites
where campsitelatitude > 42
and campsitelatitude < 49
and campsitelongitude > -124
and campsitelongitude < -117;

-- There are 102 accessible campgrounds within Oregon and Washington
select distinct on (facilityid) facilityid
from w21adb31.campsites
where campsitelatitude > 42
and campsitelatitude < 49
and campsitelongitude > -124
and campsitelongitude < -117
and campsiteaccessible = true;

-- This includes their IDs, names, lat, long, and address of the accessible campgrounds
select distinct on (F.facilityid) F.facilityid, F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
into accessiblecampgrounds
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select distinct on (facilityid) facilityid
    from w21adb31.campsites
    where campsitelatitude > 42
    and campsitelatitude < 49
    and campsitelongitude > -124
    and campsitelongitude < -117
    and campsiteaccessible = true
);

-- There are 102 in this table as well.
select * from accessiblecampgrounds;





-- 3. What are names and addresses of campgrounds with walk-to access
-- within Oregon and Washington?
-- Answer: There are 15 of them.
-- This includes their IDs, names, lat, long, and address
select distinct on (F.facilityid) F.facilityid, F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select distinct on (facilityid) facilityid
    from w21adb31.campsites
    where campsitelatitude > 42
    and campsitelatitude < 49
    and campsitelongitude > -124
    and campsitelongitude < -117
    and campsitetype = 'WALK TO'
);





-- 15. What are the names and locations of facilities offering tree permits?
-- There are 76 facilities offering tree permits
-- This gives their names, lat, and long
select distinct on (facilityid)
facilityname, facilitylongitude, facilitylatitude, facilitytypedescription
into treepermitfacilities
from facilities
where facilitytypedescription = 'Tree Permit';

select * from campsites;
select * from facilities;




-- 4. What are the names, addresses, descriptions, and count of campgrounds
-- in Oregon and Washington that have waterfront access (including beach, 
-- riverfront, or lakefront)?
-- There are 11 unique values associated with attribute value where attribute 
-- name is 'Proximity to Water'
select distinct on (AttributeValue) attributeID, AttributeValue 
from w21adb31.campsiteattributes
where AttributeName = 'Proximity to Water';

-- Confirming the query above
select distinct on (attributevalue) attributevalue
from w21adb31.campsiteattributes
where attributeID = 72;

-- CampsiteAttributes crashes the system so this limits to just the entries 
-- for proximity to water and campsites
-- 12484 rows returned
select attributevalue, entityid as campsiteid 
into waterproximityonly
from w21adb31.campsiteattributes
where attributeID = 72
and entitytype = 'Campsite';

-- Both these queries return 11445 rows/campsites with waterfront access
select * from WaterProximityOnly
where attributevalue = 'Riverfront'
or attributevalue = 'Island'
or attributevalue = 'Island,'
or attributevalue = 'Lakefront'
or attributevalue = 'Lakefront,Riverfront'
or attributevalue = 'Lakefront,Riverfront,Oceanfront'
or attributevalue = 'Oceanfront'
or attributevalue = 'Springs'
or attributevalue = 'Riverfront,Springs';

select * from waterproximityonly
where attributevalue != 'N/A';

-- There are 1420 overnight campsites with waterfront access in Oregon and Washington
-- This lists the campground name, campsite type, type of use, and type of waterfront access
select F.facilityname, A.campsitetype, A.typeofuse, A.attributevalue
from (campsites C join waterproximityonly WPO on C.campsiteid = WPO.campsiteid) A
join facilities F on A.facilityID = F.facilityID
where A.attributevalue != 'N/A'
and A.typeofuse = 'Overnight'
and A.campsitelatitude > 42
and A.campsitelatitude < 49
and A.campsitelongitude > -124
and A.campsitelongitude < -117;

-- There are 177 campgrounds with campsites with waterfront access in Oregon and Washington
-- This lists names and locations
select distinct on (F.facilityid) F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
INTO waterfrontcampgrounds
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select FC.facilityid
    from (campsites C join waterproximityonly WPO on C.campsiteid = WPO.campsiteid) A
    join facilities FC on A.facilityID = FC.facilityID
    where A.attributevalue != 'N/A'
    and A.typeofuse = 'Overnight'
)
and F.facilitylatitude > 42
and F.facilitylatitude < 49
and F.facilitylongitude > -124
and F.facilitylongitude < -117;





-- 5. Are there any campgrounds with both waterfront access and walk-to sites?
-- There are 15 campgrounds with "walk to" campsites within Oregon and Washington
-- This includes their IDs, names, lat, long, and address
select distinct on (F.facilityid) F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select distinct on (facilityid) facilityid
    from w21adb31.campsites
    where campsitelatitude > 42
    and campsitelatitude < 49
    and campsitelongitude > -124
    and campsitelongitude < -117
    and campsitetype = 'WALK TO'
)
INTERSECT
select distinct on (F.facilityid) F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select FC.facilityid
    from (campsites C join waterproximityonly WPO on C.campsiteid = WPO.campsiteid) A
    join facilities FC on A.facilityID = FC.facilityID
    where A.attributevalue != 'N/A'
    and A.typeofuse = 'Overnight'
)
and F.facilitylatitude > 42
and F.facilitylatitude < 49
and F.facilitylongitude > -124
and F.facilitylongitude < -117;

-- What are waterfront access sites that are walk-to?
select A.campsitename, F.facilityname, A.campsitetype, A.attributevalue, A.campsitelongitude, A.campsitelatitude
into waterfrontwalkto
from (campsites C join waterproximityonly WPO on C.campsiteid = WPO.campsiteid) A
join facilities F on A.facilityID = F.facilityID
where A.attributevalue != 'N/A'
and A.typeofuse = 'Overnight'
and A.campsitelatitude > 42
and A.campsitelatitude < 49
and A.campsitelongitude > -124
and A.campsitelongitude < -117
and A.campsitetype = 'WALK TO';






-- 18. How many facilities include the racial slur 'squaw' in their name?
-- Answer: 10
select facilityname, facilitylatitude, facilitylongitude
from facilities
where facilityname ilike '%squaw%';





-- 2. What are neame and addresses of campgrounds with yurts within
-- Oregon and Washington?
-- Answer: There are 10 yurt campsites in Oregon and Washington 
select *
from w21adb31.campsites
where campsitetype = 'YURT'
and campsitelatitude > 42
and campsitelatitude < 49
and campsitelongitude > -124
and campsitelongitude < -117;

-- There are four campgrounds with yurt campsites in Oregon and Washington
-- This gives their names and locations
select distinct on (F.facilityid) F.facilityid, F.facilityname, F.facilitylatitude, F.facilitylongitude, FA.facilitystreetaddress1,
FA.facilitystreetaddress2, FA.city, FA.addressstatecode, FA.postalcode
from w21adb31.facilities F join facilityaddresses FA
on F.facilityid = FA.facilityid
where F.facilityid in(
    select distinct on (facilityid) facilityid
    from w21adb31.campsites
    where campsitelatitude > 42
    and campsitelatitude < 49
    and campsitelongitude > -124
    and campsitelongitude < -117
    and campsitetype = 'YURT'
);





-- 11. What are the fees for using this site? (this includes 
-- overnight fees and permit fees)
-- There are 55 distinct rec area use fee descriptions
select distinct on (recareausefeedescription) recareausefeedescription
from recareas;

-- There are 822 distinct facility use fee descriptions
select distinct on (facilityusefeedescription) facilityusefeedescription
from facilities;

-- There are 1420 campsites with waterfront access in Oregon and Washington
-- This gives campsiteIDs and facilityIDs in a new persistent table
select C.campsiteID, C.facilityID into WaterfrontCampsiteIDs
from campsites C join waterproximityonly WPO on C.campsiteid = WPO.campsiteid
where WPO.attributevalue != 'N/A'
and C.typeofuse = 'Overnight'
and C.campsitelatitude > 42
and C.campsitelatitude < 49
and C.campsitelongitude > -124
and C.campsitelongitude < -117;

-- 159 unique facilities have campsites with waterfront access in Oregon and Washington
select distinct on (facilityid) facilityid
from WaterfrontCampsiteIDs;

-- Change data type of parentrecareaID to match recareaID in facilities and recareas tables
alter table w21adb31.facilities
alter column parentrecareaid
set data type varchar(200);

-- This lists all campsites with waterfront access and use fees
-- A lot of these are null 
select distinct on (facilityname) A.campsitename, A.loop, A.facilityname, A.facilityusefeedescription, B.recareausefeedescription
into waterfrontusefees
from (campsites C join facilities F on C.facilityID = F.facilityID) A 
join recareas B on A.parentrecareaID = B.recareaID
where A.campsiteID in (
    select campsiteid
    from WaterfrontCampsiteIDs
);

select * from waterfrontusefees;




-- 6. Which sites with waterfront access have a location rating of "Prime"?
-- Lists campsites with a location rating of prime with waterfront access in OR and WA
-- ordered by campground name, then campsite name
select campsitename, loop, facilityname, attributename, attributevalue, entityid
into primewaterfrontsites
from (campsites A join w21adb31.campsiteattributes B on A.campsiteID = B.entityID) C
join facilities D on C.facilityID = D.facilityID
where C.attributename = 'Location Rating' and
C.attributevalue = 'Prime' and
C.entityid in (
    select campsiteID
    from WaterfrontCampsiteIDs
)
order by facilityname, campsitename;

select * from primewaterfrontsites;





-- 7. Which waterfront sites allow tents only?
-- 190 campsites with waterfront access in OR and WA are tent only
select A.campsitename, A.loop, B.facilityname, A.campsitetype, A.campsiteid
into tentonly
from campsites A join facilities B on A.facilityID = B.facilityid
where A.campsiteID in (
    select campsiteid
    from WaterfrontCampsiteIDs
)
and A.campsitetype like 'TENT ONLY %'
order by B.facilityname desc, A.campsitename;

-- Allow indexing of tentonly table
alter table tentonly
add primary key (campsiteid);






-- 8. Which sites have waterfront access and a prime rating, allow tent camping only,
-- and are reservable?

-- My initial question asked this for all sites with waterfront access.
-- There are 1420 campsites with waterfront access in OR and WA that are reservable
-- This is too many to be useful so I narrowed the search a bit.
select A.campsitename, A.loop, B.facilityname, B.reservable
from campsites A join facilities B on A.facilityID = B.facilityid
where A.campsiteID in (
    select campsiteid
    from WaterfrontCampsiteIDs
)
and B.reservable = true
order by B.facilityname desc, A.campsitename;

-- Create primary key so the table can be indexed
alter table primewaterfrontsites
add primary key (entityid);

-- Which sites have waterfront access and a prime rating, allow tent camping only,
-- and are reservable?
-- There are 37 campsites like this.
select A.campsitename, A.loop, B.facilityname, B.reservable, A.campsiteid
into primetentonlywaterfrontreservable
from campsites A join facilities B on A.facilityID = B.facilityid
where A.campsiteID in (
    select campsiteid
    from tentonly
) AND
A.campsiteID in (
    select entityid
    from primewaterfrontsites
) and
A.campsiteID in (
    select campsiteid
    from WaterfrontCampsiteIDs
)
and B.reservable = true
order by B.facilityname desc, A.campsitename;

-- create a primary key to allow indexing
alter table primetentonlywaterfrontreservable
add primary key (campsiteid);






-- 9. What is the link to make a reservation (if one exists) for each site
-- with waterfront access?

-- First, check out the data in the links table.
-- What is listed in entitytype in the links table?
-- Answer: 'Asset', or 'Tour'
select distinct on (entitytype) entitytype
from links;

-- Change the data type of entityid in links table so it can be matched with other IDs
alter table links
alter column entityid
set data type varchar(200);

-- Answer: All these reservation urls are null
select facilityname, facilityreservationurl
from w21adb31.facilities
where facilityID in (
    select facilityid
    from WaterfrontCampsiteIDs
) and
facilityreservationurl <> NULL;

-- Since there are no links to make reservations, here are some links for 
-- each campground with waterfront access. 
select distinct on (D.facilityID) D.facilityID, D.facilityname, C.url
into reservationlinks
from (WaterfrontCampsiteIDs A join links B on A.facilityid = B.entityid) C
join facilities D on C.entityid = D.facilityid
where D.facilityid in (
    select facilityid
    from waterfrontcampsiteIDs
);

-- create an index to speed queries
alter table reservationlinks
add primary key (facilityID);

-- This returns 156 rows, so I'll narrow it some.
select * from reservationlinks;

-- Here are links for 
-- each campground that's prime, tent only, waterfront access, and reservable
select distinct on (A.facilityID) A.facilityname, A.url
from reservationlinks A join campsites B on A.facilityID = B.facilityID 
where B.campsiteID in (
    select campsiteid
    from primetentonlywaterfrontreservable
);





-- 10. What is the link to a map of each site (if one exists)?
-- All these map urls are null
select facilityname, facilitymapurl
from w21adb31.facilities
where facilityID in (
    select facilityid
    from WaterfrontCampsiteIDs
)
and facilitymapurl <> null;



-- 12. What percentage of the campsites are ADA accessible?
-- How is accessibility listed in this table?
-- Answer: A lot of different ways, maybe use them all?
select distinct on (attributename) attributename
from campsiteattributes;

-- What values are listed where Accessibility is an attributename?
-- Answer: Accessibility, Y
select distinct on (attributevalue) attributevalue
from w21adb31.campsiteattributes
where attributename = 'Accessibility';

-- How many sites have some kind of accessibility?
-- Answer: There are 9074 sites with some kind of accessibility
select distinct on (entityID) entityID, attributename, attributevalue
from w21adb31.campsiteattributes
where (attributename = 'Accessibility'
or attributename like 'ACCESSIBLE%')
and (attributevalue = 'Y'
or attributevalue = 'Accessibility'
or attributevalue like 'Accessible%');

-- What are all the possible values in attributevalue for accessibility?
-- Answer I put it in the query above. There are three main ones.
select distinct on (attributevalue) attributevalue
from w21adb31.campsiteattributes
where (attributename = 'Accessibility'
or attributename like 'ACCESSIBLE%');

-- How many sites are there total?
-- Answer: 102950
select distinct on (campsiteID) campsiteid
from campsites;

-- Answer 9074 / 102950 = 8.8%





-- 14. What is the total length of all paved driveway surfaces in all the campsites?
-- Casting the string to an integer. Some cleaning will help.
select attributename, cast(attributevalue as integer)
into PavedDrivewayLengthsAsInts
from w21adb31.campsiteattributes
where attributename = 'Driveway Length'
and entityid in (
    select entityid
    from w21adb31.campsiteattributes
    where attributevalue = 'Paved'
    );

drop table paveddrivewaylengths;

-- What are the attribute names used in the campsiteattributes table?
select distinct on (attributename) attributeid, attributename
from campsiteattributes;

-- What entries have non-numeric values for the length?
-- First get a table with just paved driveway lengths
-- 20463 rows returned
select attributename, attributevalue
into PavedDrivewayLengths
from w21adb31.campsiteattributes
where attributename = 'Driveway Length'
and entityid in (
    select entityid
    from w21adb31.campsiteattributes
    where attributevalue = 'Paved'
    );

select * from PavedDrivewayLengths;
-- Then check for which of these have non-numeric values

-- Find entries that won't convert to integers
-- This query returns 24 rows, so I'll just delete them
select attributevalue
from PavedDrivewayLengths
where attributevalue like '%FT%';

-- Delete rows that contain FT
-- 24 rows deleted
delete from PavedDrivewayLengths
where attributevalue like '%FT%';

-- Delete rows that contain ,
-- 1 row deleted
delete from PavedDrivewayLengths
where attributevalue like '%,%';

-- Delete rows that contain '
-- 26 rows deleted
delete from PavedDrivewayLengths
where attributevalue like '%''%';

-- Delete rows that contain ft
-- 3 rows deleted
delete from PavedDrivewayLengths
where attributevalue like '%f%';

-- Delete rows that contain x
-- 3 rows deleted
delete from PavedDrivewayLengths
where attributevalue like '%x%';

-- Now cast the lengths to ints in a new table
-- 20406 rows returned
select attributename, cast(attributevalue as integer)
into PavedDrivewayLengthsAsInts
from PavedDrivewayLengths;

-- Now get the sum of all the driveway lengths
-- Sum is 880464
select sum(attributevalue)
from PavedDrivewayLengthsAsInts;







-- 20. How many of the links associated with sites are .com versus .org?
-- Answer: 711 .orgs
select count(url) as orgSites
from w21adb31.links
where url like '%.org';
-- Answer: 2509 .coms
select count(url) as comSites
from w21adb31.links
where url like '%.com';





-- 19. What is the total duration of all tours offered and what percentage
-- of the total time is for accessible tours?
-- What is the total duration of all tours offered?
-- Answer: 61,534 hours
select sum(tourduration) as SumOfTourDurations
from tours;

-- What is the total time of accessible tours offered?
-- Answer: 13,608 hours
select sum(tourduration) as SumOfAccessibleTourDurations
from w21adb31.tours
where touraccessible = true;





-- 17. How many sites feature mushroom picking?
-- Answer: 28 campgrounds
-- Is mushroom picking an entry in activities?
-- Answer: Yes, it's in all caps
select activityname
from w21adb31.activities
group by activityname
order by activityname;

-- What is the activityID of mushroom picking?
-- Answer: 100042
select distinct on (activityname) *
from w21adb31.activities
order by activityname;

-- Which entities feature mushroom picking?
select *
from w21adb31.entityactivities
where activityid = 100042;



-- Where are gondola rides offered?
-- Answer: entity ID 233830
select * 
from w21adb31.facilities
where facilityID = '233830';



-- 13. What are the 10 activities with the fewest locations where they are offered?
select count(activityname), activityname
from w21adb31.activities
group by activityname
order by activityname;

select count(A.activityname), A.activityname
from activities A join entityactivities E on A.activityID = E.activityid
group by activityname
order by count(activityname);



-- How many sites does each of the organizations manage?
select * from organizations;

-- What are the entity types in the orgentities table?
-- Answer: Ticket Facility, Campground, Permit, Rec Area, Facility
select entitytype
from w21adb31.orgentities
group by entitytype;

-- How many entries are there for each org in the OrgEntities table?
select count(orgname), orgname
from OrgEntities E join Organizations O on E.orgid = O.orgid
group by orgname;




-- Which fee descriptions have a $value in the EntityActivities table?
-- Answer: 72 rows returned
select activityfeedescription
from w21adb31.entityactivities
where activityfeedescription like '%$%';

-- Are there any $ values in the CampsiteAttributes table?
-- Answer: No 
select attributevalue
from w21adb31.campsiteattributes
where attributevalue like '%$%';

-- Which fee descriptions have $ values in the facilities table?
-- Answer: 757 rows returned
select facilityusefeedescription
from w21adb31.facilities
where facilityusefeedescription like '%$%';
