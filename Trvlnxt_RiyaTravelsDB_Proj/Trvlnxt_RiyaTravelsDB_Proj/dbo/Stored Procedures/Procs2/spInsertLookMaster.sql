CREATE proc [dbo].[spInsertLookMaster]   
@travelFrom varchar(10)  
,@travelTo varchar(10)  
,@returnFrom varchar(10)=null  
,@returnTo varchar(10)=null  
,@travelDate datetime  
,@triptype char(1)  
,@IP varchar(50)=null  
,@travelClass varchar(10)  
,@returnDate datetime=null  
,@noOfAdult int  
,@noOfChild int   
,@noOfInfant int  
,@brawser varchar(50)=null  
,@device varchar(50)=null  
,@brawserInfo varchar(max)=null  
,@CountryFlag varchar(50)=null  
,@AirLinePreference varchar(100)=null  
,@Stop varchar(100)=null,  
@Agent varchar(50)= null  
,@Source varchar(50)=null  
,@AgentGroupId VARCHAR(3)=null
,@AgentIDF Int=null
,@StaffIDF Int=null
as  
begin  
      INSERT INTO [dbo].[LookMaster]  
           ([fromsector]  
           ,[tosector]  
           ,[travelDate]  
           ,[triptype]  
           ,[IP]  
           ,[travelClass]  
           ,[returnFrom]  
           ,[returnTo]  
           ,[returnDate]  
           ,[noOfAdult]  
           ,[noOfChild]  
           ,[noOfInfant]  
           ,[inserteddate]  
    ,[brawser]  
     ,[device]  
     ,[brawserInfo]  
     ,[AirLinePreference]  
     ,[Stop],Agent,Country,[Source],AgentIDF
	,StaffIDF
  )  
   values  
    
 (  
        @travelFrom  
    ,@travelTo  
           ,@travelDate  
           ,@triptype  
           ,@IP  
           ,@travelClass  
          ,@returnFrom  
   ,@returnTo   
           ,@returnDate  
           ,@noOfAdult  
           ,@noOfChild  
           ,@noOfInfant  
   ,GETDATE()  
  ,@brawser  
  ,@device  
  ,@brawserInfo  
  ,@AirLinePreference  
  ,@Stop,@Agent,@CountryFlag,@Source,@AgentIDF
	,@StaffIDF  
   );  
  
    exec spCheckSector @travelFrom,@travelTo,@CountryFlag,@AgentGroupId;   
    select 1 as UseCacheServerFlag    
  
DECLARE @CountryOffice varchar(10)  
  
DECLARE @officecount varchar(20)  

DECLARE @USERTYPE varchar(20)  
  
  
SET @CountryOffice = (SELECT [Country Code] FROM sectors WHERE Code =  @travelFrom)  
  
 if(@Agent!='B2C' AND @Agent!='B2B' AND @Agent!='MN')  
 BEGIN  
 SELECT @USERTYPE=(CASE WHEN userTypeID=2 THEN 'B2B' WHEN userTypeID=3 THEN 'MN' WHEN userTypeID=4 THEN 'HLD'  WHEN userTypeID=5 THEN 'RBT' END ) FROM agentLogin WHERE UserID=@Agent  
 END  
IF(@Agent='B2C')  
BEGIN  
    
sELECT @CountryOffice=CountryCode FROM tblAmadeusOfficeID   
WHERE CountryCode= @CountryFlag  AND Business=@Agent  
    
END  

 if( @Agent!='B2B' AND @Agent!='MN' AND  @Agent!='B2C') 
 begin
DECLARE @GROUPID INT 
SET @GROUPID=(SELECT GroupId FROM agentLogin WHERE UserID=@Agent)
  
  IF (@GROUPID=3)
  BEGIN
  SELECT OfficeID,Currency FROM tblAmadeusOfficeID   
	WHERE CountryCode= @CountryFlag and CompanyName='1A' AND Business=@USERTYPE  AND GROUPID =3
  END
  ELSE IF (@GROUPID=4)
  BEGIN
  SELECT OfficeID,Currency FROM tblAmadeusOfficeID   
	WHERE CountryCode= @CountryFlag and CompanyName='1A' AND Business=@USERTYPE  AND GROUPID =4
  END
  ELSE
  BEGIN
	SELECT OfficeID,Currency FROM tblAmadeusOfficeID   
	WHERE CountryCode= @CountryFlag and CompanyName='1A' AND Business=@USERTYPE  AND GROUPID IS NULL
END
end
else 
begin
SELECT OfficeID,Currency FROM tblAmadeusOfficeID   
	WHERE CountryCode= @CountryFlag and CompanyName='1A' AND Business=@Agent  AND GROUPID IS NULL
end
  
  
SELECT TOP   
1 (ROE+ (ROE*2)/100) AS ROE  
  
FROM ROE   
WHERE FromCur LIKE '%'+ @CountryOffice +'%' AND ToCur LIKE '%'+ @CountryFlag +'%'  
--AND IsActive = 1  
ORDER BY   
InserDate DESC  
  
  
SELECT TOP 1 CODE AS travelFrom FROM sectors WHERE [Country Code]='IN'  
AND CODE in  (@travelFrom,@travelTo)  

   DECLARE @travelFromCountry varchar(10), @travelTOCountry varchar(10)
   SET @travelFromCountry= (select top 1 [Country code] from sectors where code= @travelFrom)
   SET @travelTOCountry= (select top 1 [Country code] from sectors where code= @travelTo)
   IF(@travelFromCountry = @travelTOCountry)
   BEGIN
        SELECT 2 AS BindingSector;
   END
   ELSE
   BEGIN
       SELECT 6 AS BindingSector;
   END
  
  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertLookMaster] TO [rt_read]
    AS [dbo];

