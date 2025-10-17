CREATE proc [dbo].[retrivepnr] --[retrivepnr] '','','','RIYA USA'
@GDSPNR varchar(10)=''
,@cityCode varchar(3)=''
,@AirlineCode varchar(3)=''
,@AgentName varchar(max)=''
As
BEGIN
	
	if(@GDSPNR!='')
	begin
		select count(1) from tblBookMaster where GDSPNR=@GDSPNR and BookingSource not like 'offlineDesktop'
	end
	if(@cityCode!='')
	Begin
		select  NAME from tblAirportCity where CODE=@cityCode
	END
	if(@AirlineCode!='')
	Begin
		select  _NAME from AirlinesName where _CODE=@AirlineCode
	END
	if(@AgentName!='')
	Begin
		select ISNULL(AgentBalance,0) AS AgentBalance,userid from AgentLogin where UserID= @AgentName
	END

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[retrivepnr] TO [rt_read]
    AS [dbo];

