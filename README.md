# Recreation.govDB
Campsite data from Recreation.gov, the Recreation Information Database (RIDB) was used for this project. RIDB was created to share data from Recreation.gov, a collaboration between 12 federal agencies to provide recreational information and reservations to the public. Recreation.gov has been the best way to reserve good camping spots in my experience. RIDB provides this data freely as a set of .csvs and I was able to relatively easily download and start copying it into my own database. Each .csv became a table in my database, listed here with the with number of rows: Activities: 128 CampsiteAttributes: 1,880,123 Campsites: 102,950 EntityActivities: 62,745 Facilities: 14,074 FacilityAddresses: 16,392 Links: 61,119 Organizations: 29 OrgEntities: 17,524 PermitEntranceAttributes: 590 PermitEntrances: 985 PermitEntranceZones: 399 PermittedEquipment: 341,607 RecAreaAddresses: 4,046 RecAreaFacilities: 21,937 RecAreas: 3,760 TourAttributes: 1,827 Tours: 346 Primary keys and foreign keys were set for many of the more commonly queried tables. Data types for columns were altered and data was cleaned to facilitate use of foreign keys and theta joins. The questions asked for the project fell within three categories: finding campgrounds with certain amenities within Oregon and Washington, gathering information for one of these types of campgrounds that would be useful for someone wanting to choose one to make a reservation, and queries about the data as a whole. 
Query results are in the Project Report. 