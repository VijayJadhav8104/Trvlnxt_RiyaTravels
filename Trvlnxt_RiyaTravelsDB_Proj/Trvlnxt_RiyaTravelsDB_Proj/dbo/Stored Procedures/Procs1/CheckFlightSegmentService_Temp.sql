
--exec [CheckFlightSegmentService] 'VTZ','SIN','6E'    
CREATE PROCEDURE [dbo].[CheckFlightSegmentService_Temp]    
@OriginCode varchar(3),    
@DestinationCode varchar(3),    
@CarrierCode varchar(3)    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 if exists(select '1' from [RiyaTravels].[dbo].[mFlightSegments_Temp] where [OriginCode]=@OriginCode     
 and [DestinationCode]=@DestinationCode and [AirlineCode]=@CarrierCode)     
  select '1' Result;    
 else    
  select '0' Result;    
     
END    