--exec [CheckFlightSegmentService] 'VTZ','SIN','6E'    
CREATE PROCEDURE [dbo].[CheckFlightSegmentService]    
@OriginCode varchar(3),    
@DestinationCode varchar(3),    
@CarrierCode varchar(3)    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 if exists(select '1' from [RiyaTravels].[dbo].[mFlightSegments] where [OriginCode]=@OriginCode     
 and [DestinationCode]=@DestinationCode and [AirlineCode]=@CarrierCode)     
  select '1' Result;    
 else    
  select '0' Result;    
     
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckFlightSegmentService] TO [rt_read]
    AS [dbo];

