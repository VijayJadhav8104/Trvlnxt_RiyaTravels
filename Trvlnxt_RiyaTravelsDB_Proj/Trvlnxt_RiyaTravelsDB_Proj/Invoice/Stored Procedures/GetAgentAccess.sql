-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetAgentAccess]
	@Module VARCHAR(50) = NULL,
	@page int = 0,
	@size int = 0,
	@search varchar(MAX) = NULL
AS
BEGIN
	
	DECLARE @offset INT = 0
    DECLARE @newsize INT = 10
	DECLARE @totalrow INT = 0
    DECLARE @sql NVARCHAR(MAX);

    IF(@page=0)
      BEGIN
        SET @offset = @page
        SET @newsize = @size
       END
    ELSE
      BEGIN
        SET @offset = @page+1
        SET @newsize = @size-1
      END

	  ;WITH OrderedSet AS
    (
		Select 
		menu.ID AS Id
		,b2b.AgencyName AS AgencyName
		,usr.FullName AS CreatedBy
		,menu.[CreatedOn] as CreatedOn
		from mtopMenuAccess menu
		join B2BRegistration b2b on menu.AgentID = b2b.FKUserID
		join mUser usr on menu.[CreatedBy] = usr.ID
		where [Module] = @Module and Isstaff = 0
		AND ((ISNULL(@search,'') = '') or (b2b.[AgencyName] like '%'+ @search +'%') or (usr.[FullName] like '%'+ @search +'%'))
	) 
	SELECT * from (
		SELECT *
		,ROW_NUMBER() OVER (
			ORDER BY [CreatedOn] DESC
			) AS [Index]
	FROM OrderedSet) as a where a.[Index]
	BETWEEN CONVERT(NVARCHAR(12), @offset) AND CONVERT(NVARCHAR(12), (@offset + @newsize))

	--====================================================================================================================

	SET @totalrow = (SELECT COUNT(*)
		from mtopMenuAccess menu
		join B2BRegistration b2b on menu.AgentID = b2b.FKUserID
		join mUser usr on menu.[CreatedBy] = usr.ID
		where [Module] = @Module and Isstaff = 0
		AND ((ISNULL(@search,'') = '') or (b2b.[AgencyName] like '%'+ @search +'%') or (usr.[FullName] like '%'+ @search +'%'))
	)
	select @totalrow

END
