CREATE PROCEDURE [dbo].[GetMarineAttributes] --exec GetMarineAttributes 3,'IN','Amadeus','22172','I','SQ'
@UserType int,
@country varchar(5),
@GDSType varchar(10),
@AgencyId int,
@AirportType varchar(10),
@AirlineName varchar(max)
as
begin

DECLARE @attributecount as int


select @attributecount=count(s.ID) from mAttributeSegmentMapping S
INNER JOIN mAttributeMapping M ON M.ID=S.AttributeMappingId

where UserType in (select Value from mCommon where id=@UserType)
and Country=@country
and GDSType=@GDSType
and (AgencyId like '%' + cast(@AgencyId as varchar(50)) + '%' or AgencyId='0')
and (AirportType=@AirportType or AirportType='B')
and (AirlineName like  '%' + @Airlinename + '%')
and M.IsActive=1

if(@attributecount>0 )
begin
select UserType,Country,AirportType,AirlineName,AgencyId,GDSType,SegmentName,Type,[FreeText] from mAttributeSegmentMapping S
INNER JOIN mAttributeMapping M ON M.ID=S.AttributeMappingId

where UserType in (select Value from mCommon where id=@UserType)
and Country=@country
and GDSType=@GDSType
and (AgencyId like '%' + cast(@AgencyId as varchar(50)) + '%' or AgencyId='0')
and (AirportType=@AirportType or AirportType='B')
and (AirlineName like  '%' + @Airlinename + '%')
and M.IsActive=1
end
else if(@attributecount=0 and @Airlinename='All')
begin
select UserType,Country,AirportType,AirlineName,AgencyId,GDSType,SegmentName,Type,[FreeText] from mAttributeSegmentMapping S
INNER JOIN mAttributeMapping M ON M.ID=S.AttributeMappingId

where UserType in (select Value from mCommon where id=@UserType)
and Country=@country
and GDSType=@GDSType
and (AgencyId like '%' + cast(@AgencyId as varchar(50)) + '%' or AgencyId='0')
and (AirportType=@AirportType or AirportType='B')
and (AirlineName ='All')
and M.IsActive=1
end
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetMarineAttributes] TO [rt_read]
    AS [dbo];

