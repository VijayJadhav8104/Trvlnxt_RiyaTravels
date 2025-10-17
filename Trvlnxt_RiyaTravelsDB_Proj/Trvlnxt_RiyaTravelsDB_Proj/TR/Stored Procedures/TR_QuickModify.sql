CREATE PROCEDURE [TR].[TR_QuickModify]        
  @QuickFkBookingId INT = 0,    
  @QuickBookingRefId NVARCHAR(500) = '',    
  @QuickCurrentStatus NVARCHAR(500) = '',    
  @QuickBookingDate DATETIME = NULL,     
  @QuickDeadlineDate DATETIME = NULL,    
  @QuickPickupDate DATETIME = NULL,    
  @QuickPickupLocation NVARCHAR(500) = '',    
  @QuickDropOffLocation NVARCHAR(500) = '',    
  @QuickCountry NVARCHAR(500) = '',    
  @QuickCity NVARCHAR(500) = '',    
  @QuickOBTCNo NVARCHAR(500) = '',    
  @QuickCategoryVehicleType NVARCHAR(500) = '',    
  @QuickCarType NVARCHAR(500) = '',    
  @QuickEstimatedTime NVARCHAR(500) = '',    
  @QuickFlightNo NVARCHAR(500) = '',    
  @QuickFlightArrivalTime NVARCHAR(500) = '',    
  @QuickRemark NVARCHAR(500) = '',    
  @QuickCancellationPolicy NVARCHAR(MAX) = '',    
  @QuickPassengerName NVARCHAR(500) = '',    
  @QuickNationality NVARCHAR(500) = '',    
  @QuickTotalPassengers NVARCHAR(500) = '',    
  @QuickEmail NVARCHAR(500) = '',    
  @QuickContactNo NVARCHAR(500) = '',    
  @QuickPassportNumber NVARCHAR(500) = '',    
  @QuickPANCardNo NVARCHAR(500) = '',    
  @QuickNamePANCard NVARCHAR(500) = '',    
  @ModifyBy VARCHAR(50) = '',    
  @InsertedID INT OUTPUT  -- OUTPUT parameter to return inserted ID  
AS        
BEGIN        
    SET NOCOUNT ON;        
  
    -- Deactivate existing records if the Booking ID exists    
    UPDATE TR_BookingMasterQuickModify    
    SET IsActive = 0    
    WHERE FkBookingId = @QuickFkBookingId AND IsActive = 1;    
  
    -- Update main table to mark it as modified    
    UPDATE TR.TR_BookingMaster    
    SET IsModify = 1    
    WHERE BookingId = @QuickFkBookingId;    
  
    -- Insert new record    
    INSERT INTO TR_BookingMasterQuickModify (    
        FkBookingId, BookingRefId, BookingStatus, creationDate, CancellationDeadline,    
        TripStartDate, PickupLocation, DropOffLocation, CountryCode, CityName, OBTCNo,    
        CategoryVehicleType, CarName, EstimatedTime, FlightCode, FlightArrivalTime, Remark,    
        CancellationPolicyText, PassengerName, Nationality, TotalPax, Contact, Email,    
        PassportNumber, PancardNo, PanCardName, modifiedDate, ModifyBy, IsActive    
    )     
    VALUES (    
        @QuickFkBookingId, @QuickBookingRefId, @QuickCurrentStatus, @QuickBookingDate,     
        @QuickDeadlineDate, @QuickPickupDate, @QuickPickupLocation, @QuickDropOffLocation,      
        @QuickCountry, @QuickCity, @QuickOBTCNo, @QuickCategoryVehicleType, @QuickCarType,     
        @QuickEstimatedTime, @QuickFlightNo, @QuickFlightArrivalTime, @QuickRemark,        
        @QuickCancellationPolicy, @QuickPassengerName, @QuickNationality, @QuickTotalPassengers,    
        @QuickContactNo, @QuickEmail, @QuickPassportNumber, @QuickPANCardNo, @QuickNamePANCard,    
        GETDATE(), @ModifyBy, 1    
    );    
  
    -- Return the last inserted ID    
    SET @InsertedID = SCOPE_IDENTITY();    
END;  