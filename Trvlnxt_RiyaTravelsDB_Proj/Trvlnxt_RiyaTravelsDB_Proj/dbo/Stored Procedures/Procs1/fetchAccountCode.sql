
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchAccountCode]
	-- Add the parameters for the stored procedure here
	@Status varchar(max)=null,
	@AccountID int =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Status = 'A')
	BEGIN
	set @Status = 1
	END
    -- Insert statements for procedure here
	SELECT  AccountID,AirCode,AccountName,AccountCode.InsertedDate,AccountCode.InsertedBy,ModifiedDate, A.FullName AS UserName,
		case when AccountCode.Status=1 then 'Active' when AccountCode.Status=0 then 'Deactive' else '' end as Status
	FROM AccountCode   JOIN adminMaster A ON A.ID = AccountCode.InsertedBy
	WHERE  AccountCode.Status=@Status or @Status is null
		AND (AccountID = @AccountID or @AccountID=0)
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchAccountCode] TO [rt_read]
    AS [dbo];

