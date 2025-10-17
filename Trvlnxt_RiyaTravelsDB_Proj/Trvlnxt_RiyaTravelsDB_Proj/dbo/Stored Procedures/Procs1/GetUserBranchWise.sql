-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <28/09/2022>
-- Description:	<Get Branch wise user>
-- =============================================
--exec GetUserBranchWise '19'
CREATE PROCEDURE [dbo].[GetUserBranchWise]
	-- Add the parameters for the stored procedure here
	@BranchIds Varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	usr.ID,
	usr.UserName+' - '+usr.FullName as UserName
	FROM mUser AS usr  
	where usr.LocationID in (select DATA from sample_split(@BranchIds,','))
END
