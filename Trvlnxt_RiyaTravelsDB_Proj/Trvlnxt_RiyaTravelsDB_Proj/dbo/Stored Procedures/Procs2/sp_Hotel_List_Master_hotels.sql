--------Hotel_List_Master_hotels

--select * from Hotel_List_Master_hotels where Hotel_id='OT001261141';

-- EXEC 	sp_Hotel_List_Master_hotels @flag='UpdateRecord', @latitude='30.2615145', @longitude='-87.61654987', @rating='4',  @address='23916 Perdido Beach Boulevard Orange Beach Perdido Beach Boulevard', @Hotel_Id='OT001261141';

CREATE PROC [dbo].[sp_Hotel_List_Master_hotels] 
     
	 @flag VARCHAR(50) = NULL
	,@latitude VARCHAR(100) = NULL
	,@longitude VARCHAR(100) = NULL
	,@rating VARCHAR = NULL
	,@address VARCHAR(255) = NULL
	,@Hotel_Id VARCHAR(50) = NULL
	,@FileType VARCHAR(50) = NULL
AS
BEGIN

    if(@FileType = 'hotels')
	begin
		IF (@flag = 'get')
	BEGIN
		SELECT HotelName
			,CityCode
			,name
			,CountryCode
			,long_desc
			,address
			,main_image
			,Hotel_id
			,rating
			,latitude
			,longitude
		FROM Hotel_List_Master;
	END
	
		IF (@flag = 'Truncate_dummy_Table_Records')
		BEGIN
			TRUNCATE TABLE Hotel_List_Master_hotels_dummy;
		END
	
		IF (@flag = 'UpdateRecord')
		BEGIN
		UPDATE Hotel_List_Master
		SET latitude = @latitude
			,longitude = @longitude
			,address = @address
			,rating = @rating
		WHERE Hotel_id = @Hotel_Id
	END
	end


	if(@FileType = 'cities')
	begin
		IF (@flag = 'get')
	BEGIN
		SELECT ID 
		    ,CityName
			,CityCode
			,CountryName
		--	,StateId
			
		FROM Hotel_City_Master;
	END
	
		--IF (@flag = 'Truncate_dummy_Table_Records')
		--BEGIN
		--	TRUNCATE TABLE Hotel_List_Master_hotels_dummy;
		--END
	
	--	IF (@flag = 'UpdateRecord')
	--	BEGIN
	--	UPDATE Hotel_List_Master
	--	SET latitude = @latitude
	--		,longitude = @longitude
	--		,address = @address
	--		,rating = @rating
	--	WHERE Hotel_id = @Hotel_Id
	--END
	end


	if(@FileType = 'countries')
	begin
		IF (@flag = 'get')
	BEGIN
		SELECT ID 
		    ,CountryCode
			,CountryName
			
		FROM Hotel_CountryMaster;
	END
	
		--IF (@flag = 'Truncate_dummy_Table_Records')
		--BEGIN
		--	TRUNCATE TABLE Hotel_List_Master_hotels_dummy;
		--END
	
	--	IF (@flag = 'UpdateRecord')
	--	BEGIN
	--	UPDATE Hotel_List_Master
	--	SET latitude = @latitude
	--		,longitude = @longitude
	--		,address = @address
	--		,rating = @rating
	--	WHERE Hotel_id = @Hotel_Id
	--END
	end


	if(@FileType = 'nationality')
	begin
		IF (@flag = 'get')
	BEGIN
		SELECT ID 
		    ,Code
			,Nationality
			,ISOCode
			
		FROM Hotel_Nationality_Master;
	END
	
		--IF (@flag = 'Truncate_dummy_Table_Records')
		--BEGIN
		--	TRUNCATE TABLE Hotel_List_Master_hotels_dummy;
		--END
	
	--	IF (@flag = 'UpdateRecord')
	--	BEGIN
	--	UPDATE Hotel_List_Master
	--	SET latitude = @latitude
	--		,longitude = @longitude
	--		,address = @address
	--		,rating = @rating
	--	WHERE Hotel_id = @Hotel_Id
	--END
	end

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_Hotel_List_Master_hotels] TO [rt_read]
    AS [dbo];

