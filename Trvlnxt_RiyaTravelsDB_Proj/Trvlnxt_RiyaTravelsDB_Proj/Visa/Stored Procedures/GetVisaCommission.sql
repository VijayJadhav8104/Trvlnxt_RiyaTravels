--exec [Visa].[GetVisaCommission] 0,'singapore',1000
CREATE proc [Visa].[GetVisaCommission]
(
	@AgentId int NULL,
	@CountryName nvarchar(20) NULL,
	@ServiceChange decimal
	)
	as
	begin
		declare @countryid int , @Profileid int , @commission decimal(18,2) ;	
		select top 1 @countryid=Id from visa.visacountry 
		where SupplierType ='Visa' and Country =@CountryName;


		set @AgentId= 51037;
			   
		select top 1 @Profileid=Profileid from [Visa].[Visa_AgentSupplierProfileMapper]
		where isactive=1 and Supplierid=isnull(@countryid,0);--and Agentid=@AgentId 
		print(isnull(@countryid,0));
		print(isnull(@Profileid,0));


		declare @Amount decimal ,@PricePercent decimal;

	
		
		SELECT top 1 @Amount=Amount,@PricePercent=PricePercent 
		FROM PricingProfileDetails WHERE FKPricingProfile=isnull(@Profileid,0) order by CreateDate desc;

		if(@Amount >0)
		begin
		set @commission=isnull(@Amount,0);

		end 
		
		print(isnull(@commission,0))

		if(@PricePercent >0)
		begin
		set @commission=isnull(@commission,0)+ (@ServiceChange*isnull(@PricePercent,0.00)/100.00);
		end

		--select top 1 @commission=commission from  PricingProfile where isactive=1 and id=isnull(@Profileid,0);

		select isnull(@commission,0) Commission;

		/*select * from [Visa].[Visa_AgentSupplierProfileMapper]
		where isactive=1

		select * from  PricingProfile where isactive=1 and id in (35,53)
		*/

end
