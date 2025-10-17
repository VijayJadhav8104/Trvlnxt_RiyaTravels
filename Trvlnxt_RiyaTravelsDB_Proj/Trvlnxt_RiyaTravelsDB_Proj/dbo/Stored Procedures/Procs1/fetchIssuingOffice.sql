
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchIssuingOffice] --'true'
	-- Add the parameters for the stored procedure here
	@Status varchar(max)=null,
	@pid int =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  PKID as Id,AirlineCode,PseudoCode,InsertTime,modifiedDate, A.FullName AS UserName,
		case when IsActive=1 then 'Active' when IsActive=0 then 'Deactive' else '' end as [status]
	FROM [dbo].PseudoCityCode
  left JOIN adminMaster A ON A.ID = PseudoCityCode.userID
	 WHERE  IsActive=@Status or @Status is null
   AND (PKID = @pid or @pid=0)
END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchIssuingOffice] TO [rt_read]
    AS [dbo];

