    
    
                
CREATE PROCEDURE [Hotel].[AutoHCN]                
    @BookingId VARCHAR(200),                
    @HCN VARCHAR(500)                
AS                
BEGIN      
    SET NOCOUNT ON;      
    DECLARE @hotelconf VARCHAR(200);      
  DECLARE @CHECKINDATE DATE=NULL;      
      
    -- Fetch the existing HotelConfNumber        
    SELECT @hotelconf =  HCN.HotelConfirmationNumber ,    
     @CHECKINDATE = cast(HB.CheckInDate as date)    
    FROM     
 --Hotel_BookMaster HB       
        
 [Hotel].[HotelAutoHCN] HCN      
 LEFT JOIN Hotel_BookMaster HB    
       ON HB.BookingReference = HCN.BookingReference      
    WHERE HCN.BookingReference   = @BookingId;        
                
    -- Insert record only if @hotelconf is NULL or empty        
 --   IF ((@HCN IS NULL OR @HCN = '' ) AND (@HCN IS NOT NULL)  and
	--@CHECKINDATE <= DATEADD(HOUR, 48, GETDATE())  -- removed as suggested by gary at 22 aug 25
	--)
	IF (@CHECKINDATE <= DATEADD(HOUR, 48, GETDATE()))    
    BEGIN      
        BEGIN TRANSACTION;      
    
  Update [Hotel].[HotelAutoHCN] set IsActive=0 where BookingReference=@BookingId    
      
        -- Insert new record into HotelAutoHCN      
        INSERT INTO [Hotel].[HotelAutoHCN] (HotelConfirmationNumber, BookingReference, CreatedDate, IsActive)        
        VALUES (@HCN, @BookingId, GETDATE(), 1);      
      
        -- Update AutoHCNEmailSent in Hotel_BookMaster      
        UPDATE Hotel_BookMaster        
        SET AUTOHCNEMAILSENT = 1        
        WHERE BookingReference = @BookingId;      
      
        COMMIT TRANSACTION;      
    END;      
END; 