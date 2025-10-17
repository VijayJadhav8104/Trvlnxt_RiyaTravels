
	CREATE Proc [Hotel].[GetHotelPaymentmodes]

AS

BEGIN

    Select Mode, Charges
	From PaymentGatewayMode
	Where PGID=2    

END

select * from B2BPaymentMode