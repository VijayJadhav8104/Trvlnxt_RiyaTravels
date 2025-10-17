
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAgentFlag]
	-- Add the parameters for the stored procedure here		
		@OrderID varchar(30),
		@GDSPNR varchar(30)=null,
		@RiyaPNR varchar(30),
		@Remark varchar(1000),
		@UserID varchar(30)
		
AS
BEGIN
		DECLARE @Error_msg varchar(500)=null
		
		BEGIN
			IF(@OrderID IS NOT NULL)
			BEGIN
				BEGIN TRY
					UPDATE tblBookMaster
					SET
					AgentAction=1
					WHERE 
						orderId=@OrderID

					INSERT INTO AgentHistory
					(
						orderID,
						GDSPNR,
						UserID,
						Remark,
						InsertDate,
						B2BAgent
					)
					VALUES
					(
						@orderID,
						@GDSPNR,
						@UserID,						
						@Remark,						
						GETDATE(),
						1
					)
				END TRY
				BEGIN CATCH
					SET @Error_msg=ERROR_MESSAGE()
					RAISERROR(@Error_msg,16,1)
				END CATCH
			END
		END	
		
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateAgentFlag] TO [rt_read]
    AS [dbo];

