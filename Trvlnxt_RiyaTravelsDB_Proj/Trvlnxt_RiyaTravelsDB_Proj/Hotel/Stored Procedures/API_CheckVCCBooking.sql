CREATE PROC Hotel.API_CheckVCCBooking
    @BookingId VARCHAR(200) = NULL
AS
BEGIN
    IF EXISTS (
        Select BookingId from hotel.tblApiCreditCardDeatils with(nolock) where BookingId=@BookingId
    )
    BEGIN
	     IF EXISTS (Select pkid from dbo.Hotel_BookMaster with(nolock)  where BookingReference=@BookingId and B2BPaymentMode!=5)
		 BEGIN
		    SELECT 1 AS IsVCCBooking;
		 END
		 else
		  begin
            SELECT 0 AS IsVCCBooking;
          end
    END
    ELSE
    BEGIN
        SELECT 0 AS IsVCCBooking;
    END
END
