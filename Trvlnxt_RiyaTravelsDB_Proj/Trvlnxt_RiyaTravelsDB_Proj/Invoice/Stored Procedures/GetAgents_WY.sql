-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetAgents_WY] 
	
AS
BEGIN
	

	select Icast,FKUserID from B2BRegistration 
	where FKUserID in (Select AgentID from mtopMenuAccess where MenuName = 'Invoices' and Menulink not like '%warehouse%')

	delete from Invoice.Outstanding_Ageing

END
