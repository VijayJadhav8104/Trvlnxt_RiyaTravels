
-- =============================================
-- Author:		bhavika kawa
-- Description:	To update credit days for airline and hotel
-- =============================================
CREATE PROCEDURE Sp_UpdateAgentCreditDays
@ID int,
@UpdatedBy varchar(50),
@Airline bit=null,
@Hotel bit=null,
@AirlineStartDate datetime=null,
@AirlineCreditday int=null,
@HotelCreditDay int=null
AS
BEGIN
	UPDATE B2BRegistration
		SET UPDATEDBY=@UpdatedBy, 
			updatedDate= GETDATE() , 
			Airline=@Airline,
			Hotel=@Hotel,
			AirlineStartDate=@AirlineStartDate,
			AirlineCreditday=@AirlineCreditday,
			HotelCreditDay=@HotelCreditDay

			where PKID= @ID
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateAgentCreditDays] TO [rt_read]
    AS [dbo];

