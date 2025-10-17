--==================================
--Created by : Sanjay Misal
--Creation date : 25/08/2020 
-- UdspmAgentGSTMapping
--
--==================================


CREATE PROCEDURE [dbo].UdspmAgentGSTMapping
@AgentID int
AS

BEGIN
SELECT A.ID ,DisplayText,RegistrationNumber,CompanyName,CompanyAddress,GSTState as StateName ,state, ContactNo,Email,IsEditable FROM mAgentGSTMapping  A
inner join mGSTState S on A.State = S.ID
 where AgentID  =@AgentID
 order by A.ID

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspmAgentGSTMapping] TO [rt_read]
    AS [dbo];

