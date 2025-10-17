-- =============================================      
-- Author:  Satya       
-- Create date: 10.10.2024      
-- Description: Update Track id for Microservices  
-- =============================================      
CREATE PROCEDURE [dbo].[Sp_UpdateTrackIDFromMicroService]   -- exec Sp_UpdateTrackIDFromMicroService '20241009212650659642_3dc44dbb-0187-42df-9285-d4e64d3d89f6','RT20241010072054284'
 @TrackID varchar(225),
 @orderId  varchar(100)
    
AS      
BEGIN      
 update tblBookMaster set APITrackID=@TrackID  where orderId= @orderId
      
END