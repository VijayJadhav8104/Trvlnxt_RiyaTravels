


create Proc [SS].[GetHotelPaymentmodes]

AS

BEGIN

    Select Mode, Charges
	From PaymentGatewayMode
	Where PGID=2    

END
