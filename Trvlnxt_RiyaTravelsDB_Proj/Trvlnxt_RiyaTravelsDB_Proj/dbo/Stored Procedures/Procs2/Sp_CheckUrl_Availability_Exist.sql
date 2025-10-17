-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_CheckUrl_Availability_Exist]
	-- Add the parameters for the stored procedure here
	@UrlStructure nvarchar(max)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  -- declare @UrlStructure nvarchar(50)=null
--set @UrlStructure=
IF EXISTS
(SELECT UrlStructure As UrlStructure  FROM TblCity WHERE UrlStructure = @UrlStructure
union
SELECT Urlstructure  As UrlStructure  FROM TblAirline WHERE Urlstructure = @UrlStructure
union
SELECT Url  As UrlStructure  FROM Continent  WHERE Url = @UrlStructure
union
SELECT Url  As UrlStructure  FROM Conti_Country WHERE Url = @UrlStructure)
BEGIN
            SELECT 'TRUE'
      END
      ELSE
      BEGIN
            SELECT 'FALSE'
      END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_CheckUrl_Availability_Exist] TO [rt_read]
    AS [dbo];

