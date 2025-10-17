


					--				[dbo].[spGetAirport1] 'goa'
CREATE proc [dbo].[spGetAirport1] 
@searchKey varchar(50)
as
begin

	if(Len(@searchKey) = 3)
	 BEGIN 
		IF(@searchKey ='GOA')
			BEGIN
			
				SELECT CODE, Name ,COUNTRY FROM
				[dbo].[tblAirportCity] where   SEARCHNAME like @searchKey+'%' OR CODE = @searchKey
			END
		ELSE
			BEGIN	
				SELECT CODE, Name ,COUNTRY FROM
				[dbo].[tblAirportCity] where   CODE = @searchKey
			END
	 END

	 ELSE
	 BEGIN
		select top 5 Name AS Name,COUNTRY from [dbo].[tblAirportCity] where    SEARCHNAME like '%'+@searchKey+'%'
	 END

  END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetAirport1] TO [rt_read]
    AS [dbo];

