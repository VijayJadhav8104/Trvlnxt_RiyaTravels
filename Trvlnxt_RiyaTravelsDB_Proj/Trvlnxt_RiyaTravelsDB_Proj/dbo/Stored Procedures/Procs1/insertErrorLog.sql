
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertErrorLog]
	-- Add the parameters for the stored procedure here
	@page varchar(50),
	@class varchar(50),
	@method varchar(50),
	@error varchar(1000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	insert into ErrorLog(pagename_vc,classname_vc,methodname_vc,error_vc) values(@page,@class,@method,@error)
    
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertErrorLog] TO [rt_read]
    AS [dbo];

