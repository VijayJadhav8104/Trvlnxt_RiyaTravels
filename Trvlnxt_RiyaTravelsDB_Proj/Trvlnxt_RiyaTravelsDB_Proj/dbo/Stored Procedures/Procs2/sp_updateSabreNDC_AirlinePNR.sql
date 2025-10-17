
Create PROCEDURE [dbo].[sp_updateSabreNDC_AirlinePNR]
	@AirlinePNR varchar(20),
	@OrderID varchar(200),
    @isBooked bit
	 
AS
BEGIN
    Update tblBookMaster set IsBooked=@isBooked where orderId=@OrderID

	Update tblBookItenary set airlinePNR = @AirlinePNR where  orderId =@OrderID
END