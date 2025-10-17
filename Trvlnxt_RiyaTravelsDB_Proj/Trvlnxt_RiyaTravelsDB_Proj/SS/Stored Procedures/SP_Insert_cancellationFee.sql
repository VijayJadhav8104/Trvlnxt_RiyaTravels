CREATE PROCEDURE [SS].[SP_Insert_cancellationFee]  
  @BookingId INT,   
  @description varchar(max)= null,   
  @cancelIfBadWeather int= null,   
  @cancelIfInsufficientTravelers int= null  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 DECLARE @CancellationFeeId INT   
  
 INSERT INTO [SS].[SS_cancellationFee]  
           (BookingId, description, cancelIfBadWeather, cancelIfInsufficientTravelers)  
     VALUES  
           (@BookingId, @description, @cancelIfBadWeather, @cancelIfInsufficientTravelers)  
  
 SET @CancellationFeeId  =(select  SCOPE_IDENTITY())   
 SELECT @CancellationFeeId  
END  