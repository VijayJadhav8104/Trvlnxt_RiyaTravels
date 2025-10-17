CREATE proc [dbo].[spCheckSector]--[dbo].[spCheckSector] 'YYZ','YYC','IN'
@depFrom varchar(10)
,@depTo varchar(10)
,@CountryFlag VARCHAR(2)
,@AgentGroupId VARCHAR(3)=null  
as
begin
DECLARE @Sector varchar(10)
DECLARE @CountryOffice varchar(10)
declare @ROE varchar(100)
declare @sectorfrom varchar(10)

if(@AgentGroupId='4')
begin
	declare @TempCountryFlag varchar(10)
	set @TempCountryFlag= (select top 1 [Country code] from sectors where code= @depFrom)
	print @TempCountryFlag
	set @CountryFlag=@TempCountryFlag
end
if (@depFrom != @depTo)
begin
set @Sector=ISNULL((select top 1  
       (case when(count(Code)>1)  
         then 'D'  
   else 'I'  
   end) as sector  
  from sectors   
  where ((ltrim(rtrim(Code)) = @depFrom  or  
  ltrim(rtrim(Code)) = @depTo)  AND [Country code]=@CountryFlag)group by [Country Code]),'I') 
end
else
begin

set @Sector=ISNULL((select top 1  
       (case when(count(Code)=1)  
         then 'D'  
   else 'I'  
   end) as sector  
  from sectors   
  where (ltrim(rtrim(Code)) = @depFrom   AND [Country code]=@CountryFlag)
  group by [Country Code]),'I')

end

--set @Sector=ISNULL((select top 1
--       (case when(count(Code)>1)
--	        then 'D'
--			else 'I'
--			end) as sector
--  from sectors 
--  where ((ltrim(rtrim(Code)) = @depFrom  or
--		ltrim(rtrim(Code)) = @depTo)  AND [Country code]=@CountryFlag)group by [Country Code]),'I') 

		SET @CountryOffice = (SELECT [Country Code] FROM sectors WHERE Code =  @depFrom)
		set @ROE=(SELECT TOP 1 (ROE+ (ROE*2)/100) AS ROE FROM ROE  
		WHERE FromCur LIKE '%'+ @CountryOffice +'%' AND ToCur LIKE '%'+ @CountryFlag +'%' --AND IsActive = 1
		ORDER BY  InserDate DESC)
		
set @sectorfrom=(select TOP 1 'IN' AS travelFrom FROM sectors WHERE [Country Code]='IN'  
AND CODE in  (@depFrom))  

SELECT @Sector,@CountryOffice,@ROE,@sectorfrom
		
 
end


--select * from sectors
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spCheckSector] TO [rt_read]
    AS [dbo];

