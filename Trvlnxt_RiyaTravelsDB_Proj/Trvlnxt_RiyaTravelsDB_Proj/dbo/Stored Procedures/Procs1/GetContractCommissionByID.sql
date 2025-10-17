--[dbo].[GetContractCommissionByID] 39
CREATE PROCEDURE [dbo].[GetContractCommissionByID]
@ID int
AS
BEGIN

	SELECT 
	tcc.pkid,
	tcc.UserID,
	tcc.Country,
	tcc.AgentID,
	tcc.FileName,
	tcc.InsertedDate,
	--br.Icast +' - '+br.AgencyName as AgentName,
	case when (tcc.AgentId='ALL' or tcc.AgentID='0') then 'ALL' else (select stuff((select ', ' + b.Icast +' - '+b.AgencyName from AgentLogin agt
	left join B2BRegistration b on b.FKUserID=agt.UserID 
	where PATINDEX('%,'+convert(varchar,agt.UserID)+',%',','+tcc.AgentId+',')>0
	for xml path('')),1,1,'')) end as AgentName,
	tcc.UserType as UserType
	FROM tblContractCommission tcc
	--left join B2BRegistration br on tcc.AgentID=br.FKUserID
	left join mCommon com on tcc.UserID=com.ID
	WHERE tcc.pkid=@id and tcc.Status=1
END