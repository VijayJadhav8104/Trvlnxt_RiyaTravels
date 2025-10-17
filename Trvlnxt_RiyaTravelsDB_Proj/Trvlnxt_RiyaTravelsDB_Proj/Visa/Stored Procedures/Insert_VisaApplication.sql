CREATE proc [Visa].[Insert_VisaApplication]
(
	@FK_appId int NULL,
	@CreatedBy int NULL,
	@AgentID int null,
	@AgentICust nvarchar(200),
	@FK_VisaCountryMasterId int,
	@RiyaVisaPNR nvarchar(20), 
	@PassengerName nvarchar(150),
	@PassportNo nvarchar(20),
	@AgencyName nvarchar(200),
	@TravelDate Datetime
	)
	as
	begin
	declare @cnt int;
	select @cnt=count(1)from  [Visa].[ApplicationDetails] where fk_AppId=@fk_AppId;
	if(@cnt=0)
	begin
	--insert into [Visa].[ApplicationDetails](fk_AppId,CreatedBy,CreatedDate,AgentID,AgentICust,FK_VisaCountryMasterId )
	--values(@FK_appId,@CreatedBy,getdate(),@AgentID,@AgentICust,@FK_VisaCountryMasterId)

	insert into [Visa].[ApplicationDetails](fk_AppId,CreatedBy,CreatedDate,AgentID,AgentICust,FK_VisaCountryMasterId,RiyaVisaPNR ,PassengerName ,PassportNo ,AgencyName,TravelDate )
	values(@FK_appId,@CreatedBy,getdate(),@AgentID,@AgentICust,@FK_VisaCountryMasterId,@RiyaVisaPNR ,@PassengerName ,@PassportNo,@AgencyName ,@TravelDate)

	end
	end
