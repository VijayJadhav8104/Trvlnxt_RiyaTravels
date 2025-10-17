
create proc [dbo].[CMS_SetAllPageContent]
@Country varchar(100),
@PageName varchar(100)
AS
BEGIN
		SELECT Content FROM CMS_PageContent WHERE Country=@Country and PageName=@PageName
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_SetAllPageContent] TO [rt_read]
    AS [dbo];

