
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gethoteldata] --71649,'rose'
	-- Add the parameters for the stored procedure here
	@citycode varchar(max),
	@param varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  top 100 [CityCode]
      ,[HotelName] from RiyaTravels.[dbo].[Hotel_List_Master]
	where [CityCode]=@citycode and --[HotelName] like
	-- @param+'%' or
	  [HotelName] like '%'+@param+'%' 
	--  or [HotelName] like  '%'+@param
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[gethoteldata] TO [rt_read]
    AS [dbo];

