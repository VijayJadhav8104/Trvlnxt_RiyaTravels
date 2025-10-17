-- =============================================    
-- Author:  Hardik Deshani    
-- Create date: 25.06.2024    
-- Description: Update Book Details    
-- =============================================    
CREATE PROCEDURE SearchSellBookDetails_UpdateBooking    
 @TrackID Uniqueidentifier = NULL    
 ,@TrackingID Varchar(100) = NULL    
 ,@owBookMasterID BigInt = 0   
 ,@rtBookMasterID BigInt = 0   
 ,@BookingDate DateTime = null   
 ,@OUTVAL Varchar(10) OUTPUT    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 IF (@TrackID = '00000000-0000-0000-0000-000000000000' OR @TrackID IS NULL)    
 BEGIN    
  UPDATE tblSearchSellBookDetails SET Status = 'Book', BookedDate = @BookingDate    
  WHERE TrackingID = @TrackingID    
 END    
 ELSE    
 BEGIN    
  UPDATE tblSearchSellBookDetails SET Status = 'Book', BookedDate = @BookingDate    
  WHERE TrackID = @TrackID    
 END    
    
 IF(@owBookMasterID IS NOT NULL and @owBookMasterID != '')    
 BEGIN    
  UPDATE tblBookMaster SET Trackid = (CASE WHEN @TrackID = '00000000-0000-0000-0000-000000000000' OR @TrackID IS NULL THEN @TrackingID ELSE @TrackID END)    
  WHERE pkId = @owBookMasterID    
    
  IF (@rtBookMasterID > 0)    
  BEGIN    
   UPDATE tblBookMaster SET Trackid = (CASE WHEN @TrackID = '00000000-0000-0000-0000-000000000000' OR @TrackID IS NULL THEN @TrackingID ELSE @TrackID END)    
   WHERE pkId = @rtBookMasterID    
  END    
 END    
    
 SET @OUTVAL = 'OK'    
    
END