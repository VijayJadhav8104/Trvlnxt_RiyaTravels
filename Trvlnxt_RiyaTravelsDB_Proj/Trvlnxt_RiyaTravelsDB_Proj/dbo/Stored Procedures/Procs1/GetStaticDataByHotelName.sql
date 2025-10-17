
-- execute GetStaticDataByHotelName "Hotel HR Residency","Mumbai",0

CREATE PROCEDURE GetStaticDataByHotelName
	-- Add the parameters for the stored procedure here
	@HotelName varchar(max),
	@CityName varchar(200),
	@MainAgentId varchar(200)=0
AS
BEGIN
	
	

	DECLARE @str VARCHAR(max) = @HotelName
	declare @sql nvarchar(Max)
	declare @SupplierFilter nvarchar(20)

	set @SupplierFilter = (select DisplayRights from SupplierDisplayRights where FkmUserId=@MainAgentId and IsActive=1)
	
	if(@SupplierFilter is NULL)
		set @SupplierFilter='0';

		
	set @str =''''+REPLACE(@str,',',''',''')+''''

 Set @sql='
 SELECT distinct HotelName
		,name as CityName
		,short_desc
		,latitude
		,longitude
		,rating
		,address
		,phone
		,main_image as Image
		,website
		,Hotel_id
		,DisplaySupplier ='+@SupplierFilter+'
  
 FROM Hotel_List_Master 
 WHERE HotelName  IN ('+@str+') 
 and name='''+@CityName+''' 
 and latitude is not null and longitude is not null'


 exec sp_executesql @sql

	

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetStaticDataByHotelName] TO [rt_read]
    AS [dbo];

