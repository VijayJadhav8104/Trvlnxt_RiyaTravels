-- =============================================
-- Author:	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckIsUserExist]
-- Add the parameters for the stored procedure here
@Username nvarchar(200)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT count(UserID) FROM UserLogin WHERE UserName=@Username

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckIsUserExist] TO [rt_read]
    AS [dbo];

