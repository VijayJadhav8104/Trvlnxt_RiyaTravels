-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Insert_CityInfo]
	@citycode varchar(max),
	@cityname varchar(50),
	@countryid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from Hotel_City_Master where CityCode=@citycode and CityName=@cityname and CountryID=@countryid)
	begin
    INSERT INTO Hotel_City_Master
          ( 
              CityCode,
			  CityName,
			  CountryID            
          ) 
     VALUES 
          ( 
				@citycode,
				@cityname,
				@countryid

            
          ) 
end
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Insert_CityInfo] TO [rt_read]
    AS [dbo];

