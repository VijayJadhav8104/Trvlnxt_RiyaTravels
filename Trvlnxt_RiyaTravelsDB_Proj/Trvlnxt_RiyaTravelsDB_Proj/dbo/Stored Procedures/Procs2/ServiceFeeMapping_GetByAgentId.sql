
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ServiceFeeMapping_GetByAgentId]
	@AgentID int
AS
BEGIN
select  
Id
,AgentID 
,AirportType
,AirlineCategory
,AirlineName
,AirlineCode
,AdultServiceFee
,ChildServiceFee
,InfantServiceFee
,InsertedDate from  tblAgentServiceFeeMapping where 
(AgentID=@AgentID or AgentID in (select ParentAgentID from AgentLogin where UserID = @AgentID and ParentAgentID is not null))
END







