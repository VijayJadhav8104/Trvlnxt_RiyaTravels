 Create Procedure Proc_GetHotelCommonAgentPaymentGatewayModes 
 @AgentCurrency varchar(50)='',
 @BookingAgencyCountry varchar(50)=''
 as    
 Begin 
	if(@AgentCurrency='SAR' and @BookingAgencyCountry='SA')
	BEGIN
		Select Mode, Charges  From PaymentGatewayMode Where PGID=11  
	END
	ELSE IF(@AgentCurrency='AED' and @BookingAgencyCountry='AE')
	BEGIN
		Select Mode, Charges From PaymentGatewayMode Where PGID=10  
	END
	ELSE IF(@AgentCurrency='USD' and @BookingAgencyCountry='US')
	BEGIN
		Select Mode, Charges From PaymentGatewayMode Where PGID=8  
	END
	ELSE
	BEGIN
		Select Mode, Charges  From PaymentGatewayMode Where PGID=2  
	END
 END