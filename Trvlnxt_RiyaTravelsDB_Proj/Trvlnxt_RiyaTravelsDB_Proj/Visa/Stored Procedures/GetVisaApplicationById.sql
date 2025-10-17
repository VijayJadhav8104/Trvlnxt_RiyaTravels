CREATE proc [Visa].[GetVisaApplicationById]
(
	@Id int NULL
	)
	as
	begin

	select  visa.ApplicationDetails.*, PaymentStatus ,VisaFees,VFSFees ,GST,ServiceCharges ,Markup
	from visa.ApplicationDetails  left join  visa.ApplicationPayment
	on (PaymentStatus =1 and visa.ApplicationDetails.fk_AppId=visa.ApplicationPayment.fk_AppId)
	where visa.ApplicationDetails.fk_AppId=@id ;
	
	end
