-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_AuditInsert] 
	-- Add the parameters for the stored procedure here
	@Message text=null,
	@AuditType nvarchar(30)=null,
	@UserId int=null,
	@UserName nvarchar(50)=null,
	@PageName nvarchar(70)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into TblAudit(
	Message,
	AuditType,
	UserId,UserName,
	PageName,
	CurrentTimeStamp)
	values (
	@Message,
	@AuditType,
	@UserId,
	@UserName,
	@PageName,
	SYSDATETIME())
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_AuditInsert] TO [rt_read]
    AS [dbo];

