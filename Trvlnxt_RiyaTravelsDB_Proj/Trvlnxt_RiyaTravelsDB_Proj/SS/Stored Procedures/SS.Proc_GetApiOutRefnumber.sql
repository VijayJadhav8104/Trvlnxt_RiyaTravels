
create procedure [SS].[SS.Proc_GetApiOutRefnumber]
@bookingRefId as varchar(50) =null,
@actBookingId as varchar(50) =null,
@correlationId as varchar(max),
@BookingPortal as varchar(25)
as
begin

select  @actBookingId= CONCAT('TNAAPI',FormaT((cast(isnull(MAX(ID),0)as bigint)+1),'0000000'))
 --into
FROM [SS].[SS_ActAPIOutData] 

 insert into [SS].[SS_ActAPIOutData]
 (actBookingId,
bookingRefId, 
CorrelationID,
BookingPortal)
 values
  (@actBookingId,
@bookingRefId,
@correlationId,
@BookingPortal)

select @actBookingId 'actBookingId'
--from [SS].[SS_ActAPIOutData] order
END
 
