
CREATE proc [dbo].[spInsertCacheInfo]
	@cacheKey varchar(100),
	@travelDate date,
	@travelFrom varchar(10),
	@travelTo varchar(10),
	@travelClass varchar(10),
	@returnFrom varchar(10)=null,
	@returnTo varchar(10)=null,
	@returnDate date=null,
	@noOfAdult int,
	@noOfChild int,
	@noOfInfant int,
	@expiredOn datetime,
	@cachedOn datetime,
	@FlightSearchData varchar(max),
	@sector varchar(20)=NULL,
	@IsSpecialSector bit=0
	as
begin

if not exists(select cacheKey from tblCacheMaster where ltrim(rtrim(cacheKey))=ltrim(rtrim(@cacheKey)))
begin
  INSERT INTO [dbo].[tblCacheMaster]
           ([cacheKey]
           ,[travelDate]
           ,[travelFrom]
           ,[travelTo]
           ,[travelClass]
           ,[returnFrom]
           ,[returnTo]
           ,[returnDate]
           ,[noOfAdult]
           ,[noOfChild]
           ,[noOfInfant]
           ,[expiredOn]
           ,[cachedOn]
		   ,FlightSearchData
		   ,sector
	
		   ,[IsSpecialSector]
           )
     VALUES
           (
		    @cacheKey
           ,@travelDate
           ,@travelFrom
           ,@travelTo
           ,@travelClass
           ,@returnFrom
           ,@returnTo
           ,@returnDate
           ,@noOfAdult
           ,@noOfChild
           ,@noOfInfant
           ,@expiredOn
           ,@cachedOn
           ,@FlightSearchData
		   ,@sector

		   ,@IsSpecialSector
           )
  insert into [dbo].[tblCacheMasterLog]([cacheKey],remark) values(@cacheKey,'spInsertCacheInfo Inserted,Cache Key Not Exist');
end
else
begin
  UPDATE [dbo].[tblCacheMaster]
   SET 
      [travelDate] = @travelDate
      ,[travelFrom] = @travelFrom
      ,[travelTo] = @travelTo
      ,[travelClass] = @travelClass
      ,[returnFrom] = @returnFrom
      ,[returnTo] = @returnTo
      ,[returnDate] = @returnDate
      ,[noOfAdult] = @noOfAdult
      ,[noOfChild] = @noOfChild
      ,[noOfInfant] = @noOfInfant
      ,[expiredOn] = @expiredOn
      ,[cachedOn] = @cachedOn
      ,[FlightSearchData] = @FlightSearchData
	  ,sector=@sector
	  ,[IsSpecialSector]=IsSpecialSector
 WHERE cacheKey=@cacheKey;
  insert into [dbo].[tblCacheMasterLog]([cacheKey],remark) values(@cacheKey,'spInsertCacheInfo Updated,Cache Key Already Exist');
end
--select SCOPE_IDENTITY();

end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertCacheInfo] TO [rt_read]
    AS [dbo];

