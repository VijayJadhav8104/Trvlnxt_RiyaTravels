--exec  [Visa].[SearchVisaBooking] 0,0,'','',0,'','','','30-Apr-2024'
CREATE proc [Visa].[SearchVisaBooking]
(
	@RiyaUserID int NULL=0,
	@AgentID int NULL=0,	
	@FromDate nvarchar(20),
	@ToDate nvarchar(20),
	@FK_VisaCountryMasterId int,
	@RiyaVisaPNR nvarchar(20), 
	@PassengerName nvarchar(150),
	@PassportNo nvarchar(20),
	@TravelDate nvarchar(20)
	)
	as
	begin	

	select A.* ,isnull(P.TotalAmount,0) TotalAmount
	from  visa.ApplicationDetails A left join [Visa].[ApplicationPayment] P
	on (A.fk_appid= P.fk_appid and P.PaymentStatus=1)
	where (@FK_VisaCountryMasterId=0 or FK_VisaCountryMasterId = @FK_VisaCountryMasterId)
	and (@RiyaVisaPNR='' or RiyaVisaPNR=TRIM(@RiyaVisaPNR))
	and (@PassengerName='' or PassengerName like '%'+TRIM(@PassengerName)+'%')
	and (@PassportNo='' or PassportNo=@PassportNo)
	and (@AgentID=0 or @AgentID =AgentID)
	--and (@AgentICust='' or AgentICust=@AgentICust) 
	/*and (@FromDate='' or (@FromDate!='' and convert(date,CreatedDate)  >=convert(date,@FromDate)))
	and (@ToDate='' or (@ToDate!='' and convert(date,CreatedDate) <=convert(date,@ToDate)))
	and (@TravelDate='' or (@TravelDate!='' and TravelDate is not null and convert(date,TravelDate ) =convert(date,@TravelDate)) )
	*/
	order by id desc
	
	end
