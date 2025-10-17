-- =============================================  
-- Author:  Hardik Deshani  
-- Create date: 25.06.2024  
-- Description: Insert Search Office ID  
-- =============================================  
CREATE PROCEDURE SearchVendorDetails_Insert  
 @TrackID Uniqueidentifier = NULL  
 ,@TrackingID Varchar(MAX) = NULL  
 ,@OfficeID Varchar(MAX) = ''
 ,@Caching bit = 0
 ,@OUTVAL Varchar(10) OUTPUT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
    INSERT INTO tblSearchVendorDetails (TrackID, TrackingID,Caching,OfficeID)   
 SELECT @TrackID, @TrackingID,@Caching,Item FROM dbo.SplitString(@OfficeID, ',') WHERE Item != ''
  
 SET @OUTVAL = 'OK'  
  
END