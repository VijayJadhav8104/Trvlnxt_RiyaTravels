-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdateAgentAccess]
	@Module VARCHAR(50) = NULL,
	@Action VARCHAR(50) = NULL,
	@AgentId bigint = 0,
	@CreatedBy bigint = 0,
	@Id bigint = 0
AS
BEGIN
	
	IF @Action = 'Check'
	BEGIN
		
		SELECT COUNT(ID) FROM mtopMenuAccess WHERE AgentID = @AgentId and Isstaff = 0

	END
	ELSE IF @Action = 'Add'
	BEGIN
		
		IF @Module = 'Warehouse'
		BEGIN
			INSERT INTO mtopMenuAccess(AgentID,MenuName,Menulink,Isstaff,Module,CreatedBy) VALUES(@AgentId,'Invoices','https://trvlnxt.com/Invoices/Warehouse/Index',0,@Module,@CreatedBy)
		END
		ELSE IF @Module = 'Winyatra'
		BEGIN
			INSERT INTO mtopMenuAccess(AgentID,MenuName,Menulink,Isstaff,Module,CreatedBy) VALUES(@AgentId,'Invoices','https://trvlnxt.com/Invoices/',0,@Module,@CreatedBy)
		END

	END
	ELSE IF @Action = 'Delete'
	BEGIN
		
		DELETE FROM mtopMenuAccess where ID = @Id

	END

END
