-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_Continent_Select]
@Id int = null,
@Query varchar(50) = null
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
    -- Insert statements for procedure here
	if(@Query =  1)
	SELECT * from Continent where Id = @Id;
	
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Continent_Select] TO [rt_read]
    AS [dbo];

