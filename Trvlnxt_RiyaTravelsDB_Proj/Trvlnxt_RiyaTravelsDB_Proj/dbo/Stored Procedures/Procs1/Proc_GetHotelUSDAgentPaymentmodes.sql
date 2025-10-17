
	Create Procedure Proc_GetHotelUSDAgentPaymentmodes
	as
	Begin
	  Select Mode, Charges
		From PaymentGatewayMode
		Where PGID=8
	END