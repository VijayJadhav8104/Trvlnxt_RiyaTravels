--exec [dbo].[GetContractCommission] 'B2B','IN',NULL
CREATE procedure [dbo].[GetContractCommission]
@UserType varchar(10),
@Country varchar(10),
@AgentId int=0

as

begin
if(@AgentId>0)
BEGIN
	select cc.pkid as ID,  CC.Country,
	case when (CC.AgentId='ALL' or cc.AgentID='0') then 'ALL' else (select stuff((select ', ' + b.Icast +' - '+b.AgencyName from AgentLogin agt
	left join B2BRegistration b on b.FKUserID=agt.UserID 
	where PATINDEX('%,'+convert(varchar,agt.UserID)+',%',','+CC.AgentId+',')>0
	for xml path('')),1,1,'')) end as AgencyName,
	CC.FileName,CC.InsertedDate from tblContractCommission CC
	--INNER JOIN B2BRegistration AL on AL.FKUserID=CC.AgentID 
	where cc.status=1
	--and cc.AgentID!=0
	--AND AgentID=@AgentId 
	and  (@AgentId is null OR @AgentId=0 OR @AgentId in (SELECT Item FROM dbo.SplitString(AgentID,',')))
	and UserType=@UserType 
	AND CC.country=@Country
	order by cc.InsertedDate desc
END
ELSE
BEGIN
	select cc.pkid as ID,  
	CC.Country,
	--'All' as AgencyName,
	case when (CC.AgentId='ALL' or cc.AgentID='0') then 'ALL' else (select stuff((select ', ' + b.Icast +' - '+b.AgencyName from AgentLogin agt
	left join B2BRegistration b on b.FKUserID=agt.UserID 
	where PATINDEX('%,'+convert(varchar,agt.UserID)+',%',','+CC.AgentId+',')>0
	for xml path('')),1,1,'')) end as AgencyName,
	CC.FileName,CC.InsertedDate from tblContractCommission CC
	--INNER JOIN B2BRegistration AL on AL.FKUserID=CC.AgentID 
	where cc.status=1
	AND ( @AgentId is null OR @AgentId='0' OR cc.AgentID=0)
	AND UserType=@UserType 
	AND CC.country=@Country
	order by cc.InsertedDate desc
END
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetContractCommission] TO [rt_read]
    AS [dbo];

