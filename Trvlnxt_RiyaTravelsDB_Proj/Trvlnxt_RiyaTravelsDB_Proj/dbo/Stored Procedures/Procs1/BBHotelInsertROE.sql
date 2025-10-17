-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE BBHotelInsertROE
	
	@FkBookId int=0,
	@BookingRefNo varchar(200)=null,
	@FromCurrency varchar(100)=null,
	@ToCurrency varchar(100)=null,
	@FkROE_Id int=0,
	@Rate varchar(200)=null

AS
BEGIN
	
	insert into Hotel_ROE_Booking_History (FkBookId,BookingRefNo,FromCurrency,ToCurrency,FkROE_Id,Rate) 
	values(@FkBookId,
	      @BookingRefNo,
		  @FromCurrency,
		  @ToCurrency,
		  @FkROE_Id,
		  @Rate)

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBHotelInsertROE] TO [rt_read]
    AS [dbo];

