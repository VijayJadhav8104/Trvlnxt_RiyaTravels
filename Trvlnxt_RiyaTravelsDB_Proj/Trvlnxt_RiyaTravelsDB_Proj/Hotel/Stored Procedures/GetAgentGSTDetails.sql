

Create Proc [Hotel].GetAgentGSTDetails
@AgentID int=0
AS
BEGIN
 select RegistrationNumber as 'gstNumber',
        CompanyName as 'companyName',
		CompanyAddress as 'companyAddress',
		ContactNo as 'contactNumer',
		Email as 'email'
		from mAgentGSTMapping where AgentID=@AgentID
END