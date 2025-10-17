
  
  
CREATE PROCEDURE ModifyBooking    
    @BookingRef VARCHAR(20),    
    -- @BookingStatus NVARCHAR(255),    
    --@FkStatusID int,    
    @ServiceFromDate Datetime,    
    @ServiceToDate Datetime,    
    @NumberOfNights INT,    
    @HotelName varchar(500),    
    @HotelAddress varchar(500),    
    @HotelPhoneNo varchar(15),    
    @UpdatedBy int ,    
    @Id INT    
AS    
BEGIN    
    BEGIN TRANSACTION; -- Start a transaction  
  
    -- Declare variables to hold the old values  
    DECLARE @OldCheckInDate DATETIME;  
    DECLARE @OldCheckOutDate DATETIME;  
    DECLARE @OldSelectedNights INT;  
    DECLARE @OldHotelName VARCHAR(500);  
    DECLARE @OldHotelAddress VARCHAR(500);  
    DECLARE @OldHotelPhoneNo VARCHAR(15);  
  
    -- Retrieve the old values  
    SELECT  
        @OldCheckInDate = CheckInDate,  
        @OldCheckOutDate = CheckOutDate,  
        @OldSelectedNights = SelectedNights,  
        @OldHotelName = HotelName,  
        @OldHotelAddress = HotelAddress1,  
        @OldHotelPhoneNo = HotelPhone  
    FROM Hotel_BookMaster  
    WHERE pkId = @Id;  
  
    -- Insert a record into the history table  
    INSERT INTO Hotel_UpdatedHistory(fkbookid, fieldname, FieldValue, InsertedDate, InsertedBy, UpdatedType)    
    VALUES    
        (@Id, 'ModifiedBooking',   
         CONCAT(@OldCheckInDate,',',@OldCheckOutDate,',',@OldHotelAddress,',',@OldHotelName,',',@OldHotelPhoneNo,',',@OldSelectedNights),   
         GETDATE(), @UpdatedBy, 'Console_Modify');  
  
    -- Update the CT table  
    UPDATE Hotel_BookMaster  
    SET  
        BookingReference = @BookingRef,  
        CheckInDate = TRY_CONVERT(DATETIME, @ServiceFromDate, 106),  
        CheckOutDate = TRY_CONVERT(DATETIME, @ServiceToDate, 106),  
        SelectedNights = @NumberOfNights,  
        HotelName = @HotelName,  
        HotelAddress1 = @HotelAddress,  
        HotelPhone = @HotelPhoneNo  
    WHERE  
        pkId = @Id;  
  
    COMMIT; -- Commit the transaction  
END  