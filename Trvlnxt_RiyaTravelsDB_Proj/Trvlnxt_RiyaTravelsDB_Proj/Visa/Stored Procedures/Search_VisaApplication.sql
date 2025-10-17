CREATE proc [Visa].[Search_VisaApplication]
(
	@UserID int NULL,
	@AgentID int NULL,	
	@AgentICust nvarchar(200),	
	@FromDate nvarchar(20),
	@ToDate nvarchar(20),
		@FK_VisaCountryMasterId int,
	@RiyaVisaPNR nvarchar(20), 
	@PassengerName nvarchar(150),
	@PassportNo nvarchar(20)
	)
	as
	begin

	select  * from visa.ApplicationDetails 
	where (@FK_VisaCountryMasterId=0 or FK_VisaCountryMasterId = @FK_VisaCountryMasterId)
	and (@RiyaVisaPNR='' or RiyaVisaPNR=@RiyaVisaPNR)
	and (@PassengerName='' or PassengerName like '%'+@PassengerName+'%')
	and (@PassportNo='' or PassportNo=@PassportNo)
	and (@AgentICust='' or AgentICust=@AgentICust) 
	and (@FromDate='' or (@FromDate!='' and convert(date,CreatedDate)  >=convert(date,@FromDate)))
	and (@ToDate='' or (@ToDate!='' and convert(date,CreatedDate) <=convert(date,@ToDate)))
	--and (@TravelDate='' or (@TravelDate!='' and TravelDate!=null and convert(date,TravelDate ) =convert(date,@TravelDate)) )
	order by id desc

	
	end
