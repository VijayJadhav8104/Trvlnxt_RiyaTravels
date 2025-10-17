CREATE procedure [dbo].[GetContractCommissionByAgentID]
@agentid Int
as

begin

select cc.pkid as ID,  CC.Country,AL.AgencyName,CC.FileName,CC.InsertedDate from tblContractCommission CC
INNER JOIN B2BRegistration AL on AL.FKUserID=CC.AgentID
where cc.status=1 and AL.FKUserID=@agentid

union

select cc.pkid as ID,  CC.Country,'All' as 'AgencyName',CC.FileName,CC.InsertedDate from tblContractCommission CC

where cc.status=1 and cc.AgentID=0 and cc.Country=(select BookingCountry from AgentLogin where UserID=@agentid)
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetContractCommissionByAgentID] TO [rt_read]
    AS [dbo];

