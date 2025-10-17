




CREATE procedure [dbo].[Delete_Flat]
@ID int,
@DeletedBy varchar(50)

as
begin

if Exists (select * from  Flight_Flat where ID= @ID)
begin

Insert into FlightFlat_Delete
(

FlatID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
InsertedDate,
DeletedBy,
DeletedDate,
Origin	,
OriginValue	,
Destination	,
DestinationValue,
Flightseries,
FlightseriesValue	,
cabin
)

select 

@ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
InsertedDate,
@DeletedBy,
GETDATE(),
Origin	,
OriginValue	,
Destination	,
DestinationValue,
Flightseries,
FlightseriesValue	,
cabin


from Flight_Flat

where ID= @ID


Insert into FlightFlatDrec_Delete
(

FlatID,
FKID,
Min,
Max,
Discount
)
select
@ID,
FKID,
Min,
Max,
Discount

from FlightFlat_Drec where  FKID= @ID




delete from Flight_Flat where ID= @ID

delete from FlightFlat_Drec where FKID = @ID


end


end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_Flat] TO [rt_read]
    AS [dbo];

