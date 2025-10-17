
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_UpdateJob]
	-- Add the parameters for the stored procedure here
	@id bigint,
	@title varchar(50),
	@descrptn text,
	@location varchar(50),
	@experience varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@id=0)
    begin
    insert into CMS_JOB(Title,Description,Experince,Location) values(@title,@descrptn,@experience,@location)
    select 1
    end
    else
    begin
    update CMS_JOB set Title=@title,Description=@descrptn,Location=@location,Experince=@experience where PKID=@id
    select 2
    end
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_UpdateJob] TO [rt_read]
    AS [dbo];

