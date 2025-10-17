-- =============================================  
-- Author:  Hardik Deshani  
-- Create date: 25.06.2024  
-- Description: Update Air Sell  
-- =============================================  
CREATE PROCEDURE SearchSellBookDetails_UpdateSell  
 @TrackID Uniqueidentifier = NULL  
 ,@TrackingID Varchar(100) = NULL  
 ,@SellDate DateTime  = null
 ,@FareAmount Numeric(18,2)  
 ,@OfficeID Varchar(50)  
 ,@ArlineCode Varchar(10)  
 ,@Origin Varchar(10)  
 ,@Destination Varchar(10)  
 ,@OUTVAL Varchar(10) OUTPUT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 IF (@TrackID = '00000000-0000-0000-0000-000000000000' OR @TrackID IS NULL)  
 BEGIN  
  UPDATE tblSearchSellBookDetails SET SellDate = @SellDate  
  , FareAmount = @FareAmount  
  , OfficeID = @OfficeID  
  , ArlineCode = @ArlineCode  
  , Status = 'Sell'  
  WHERE TrackingID = @TrackingID  
  AND Origin = @Origin  
  AND Destination = @Destination  
 END  
 ELSE  
 BEGIN  
  UPDATE tblSearchSellBookDetails SET SellDate = @SellDate  
  , FareAmount = @FareAmount  
  , OfficeID = @OfficeID  
  , ArlineCode = @ArlineCode  
  , Status = 'Sell'  
  WHERE TrackID = @TrackID  
  AND Origin = @Origin  
  AND Destination = @Destination  
 END  
  
 SET @OUTVAL = 'OK'  
  
END