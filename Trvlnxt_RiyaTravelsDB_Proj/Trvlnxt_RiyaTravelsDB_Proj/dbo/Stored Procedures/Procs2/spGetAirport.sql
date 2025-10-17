
CREATE proc [dbo].[spGetAirport] 
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
		select top 5 Name AS Name,COUNTRY,CODE from [dbo].[tblAirportCity] where    SEARCHNAME like '%'+@searchKey+'%'
	 END
--if(Len(@searchKey) = 3)
-- begin
-- CREATE TABLE #TAMP(
 
-- CODE VARCHAR(10),
-- Name VARCHAR(1000),
-- COUNTRY VARCHAR(100)
-- )

	 
--	 IF(EXISTS(SELECT 1 FROM tblAirportCity WHERE  SEARCHNAME LIKE '%'+@searchKey+'%'))
--	 BEGIN
--			INSERT INTO #TAMP (CODE, Name,COUNTRY) SELECT CODE, Name ,COUNTRY FROM
--			[dbo].[tblAirportCity] where   CODE = @searchKey

--			INSERT INTO #TAMP (CODE, Name,COUNTRY) SELECT TOP 4 CODE, Name,COUNTRY FROM
--			[dbo].[tblAirportCity] where SEARCHNAME LIKE '%'+@searchKey+'%'  
			
--			SELECT CODE, Name AS Name,COUNTRY FROM #TAMP
--	 END

--	 ELSE
--	 BEGIN
--		select top 5 Name AS Name,COUNTRY from [dbo].[tblAirportCity] where   CODE = @searchKey
--	 END

   
-- end
-- else
-- begin
   
--	select top 5 Name AS Name,COUNTRY from [dbo].[tblAirportCity] where SEARCHNAME like '%'+@searchKey+'%'

-- end
end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetAirport] TO [rt_read]
    AS [dbo];

