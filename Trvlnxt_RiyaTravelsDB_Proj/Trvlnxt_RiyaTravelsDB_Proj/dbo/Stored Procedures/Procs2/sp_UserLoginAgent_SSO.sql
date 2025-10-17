CREATE PROCEDURE [dbo].[sp_UserLoginAgent_SSO] -- [sp_UserLoginAgent] 'manasvee@riya.travel','123456789'        
@UserName varchar(100),        
@Password varchar(200),        
@Device VARCHAR(50) = NULL,        
@IPAddress VARCHAR(50) = NULL,        
@Browser VARCHAR(50) = NULL,        
@SessionID VARCHAR(50) = NULL,        
@EncryptPassword varchar(200) = NULL,        
@visitorId varchar(max) = NULL,        
@deviceinfo varchar(max) = NULL,        
@CheckPassword bit = 1,   
@DRCheckBoxTime datetime = NULL,   
@UserLoginCountry varchar(100)=NULL, 
@RequestTimeZone varchar(100)= NULL,  
@IsLocked INT OUTPUT ,
@IsActive INT OUTPUT         
        
AS        
BEGIN        
  DECLARE @UserID INT, @UserType varchar(10)         
  SET @IsLocked = 0     
  SET @IsActive =1

  IF EXISTS (SELECT 1 FROM mUser WHERE UserName = @UserName AND isActive = 0)
    OR EXISTS (SELECT 1 FROM AgentLogin WHERE UserName = @UserName AND IsActive = 0)
    BEGIN
    SET @IsActive = 0
  END

  DECLARE @LoginAttempt INT, @AttemptNo INT, @AttemptedDate Datetime        
  SELECT @LoginAttempt = LoginAttempt , @AttemptNo = AttemptNo , @AttemptedDate = AttemptedDate         
  FROM mUser         
  WHERE UserName = @UserName AND isActive = 1        
  SET @AttemptedDate = ISNULL(@AttemptedDate, DATEADD(minute,-1,GETDATE()))        
  IF(@AttemptedDate < GETDATE() OR @LoginAttempt = 0)        
  BEGIN        
   IF(@CheckPassword = 0)        
   BEGIN        
    SELECT @UserID = ID,@EncryptPassword = password  FROM mUser WHERE UserName = @UserName AND isActive = 1        
   END         
   ELSE         
   BEGIN        
    SELECT @UserID = ID  FROM mUser WHERE UserName = @UserName  
 --AND Password = @EncryptPassword  
     AND isActive = 1         
   END        
        
   IF(@UserID IS NULL)        
   BEGIN        
    SELECT @UserID = UserID  FROM AgentLogin WHERE UserName = @UserName 
	AND(PasswordEncrypt IS NOT NULL AND PasswordEncrypt = @EncryptPassword 
       OR PasswordEncrypt IS NULL AND Password = @Password)
	--AND Password = @Password 
	AND IsActive = 1        
    SET @UserType = 'Agent'        
   END        
   ELSE        
   BEGIN        
    SET @UserType = 'User'        
   END        
        
   IF(@UserID IS NULL)        
   BEGIN        
    SET @UserType = ''        
   END        
        
   --   IF(@UserType = '')        
   --BEGIN        
            
   --   SELECT LoginAttempt = @LoginAttempt,AttemptNo = @AttemptNo,AttemptedDate = @AttemptedDate FROM mUser WHERE UserName = @UserName AND Password = @EncryptPassword AND isActive = 1        
        
   --   update mUser SET AttemptNo = ISNULL(AttemptNo,0) +1 , LoginAttempt = 0,AttemptedDate = GETDATE() WHERE UserName = @UserName        
        
   --IF((select AttemptNo FROM mUser WHERE UserName = @UserName) >6)        
   --   BEGIN         
   --    SET @IsLocked = 1        
   --      SET @AttemptedDate = DATEADD(minute,30,GETDATE())        
   --   update mUser SET  AttemptedDate = @AttemptedDate,LoginAttempt = 1,AttemptNo = 0 WHERE UserName = @UserName        
   -- end        
   -- end        
   -- else        
   -- BEGIN        
   -- update mUser SET AttemptNo = 0,LoginAttempt = 0,AttemptedDate = GETDATE() WHERE UserName = @UserName        
   -- end        
    if(@UserType = 'User')  
 begin  
    SELECT U.ID         
   , 1 AS UserLevel        
   , isResetPassword        
   , C.Value AS UserType        
   , U.AgentBalance AS MainAgentBalance        
   , u.FullName         
   , '' AS BookingCountry         
   , U.GhostTrack AS GhostTrack        
   , U.NewSelfBalance AS NewSelfBalance        
   , U.SelfBalance AS 'SelfBalanceAccess' --Add Ketan Marade        
   , U.GroupId AS 'GroupId'  
   , U.NewGroupid AS 'NewGroupid'      
   , U.EmployeeNo AS EmpCode        
   , '' AS Icast        
   , U.UserDeviceID as UserDeviceID      
   , U.EmailID as EmailID      
   , '' as ParentFullName    
   ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft   
   ,U.LastLoginDate as LastLoginDate
   ,U.OTPRequired  
    ,STUFF((SELECT ',' + CountryCode from mCountry WITH (NOLOCK) where ID IN (select CountryId from mUserCountryMapping where isActive = 1 and UserId = U.ID) FOR XML PATH('')),1,1,'') as CountryCode 
    FROM mUser U        
    INNER JOIN mUserTypeMapping UT on UT.UserId = U.ID        
    INNER JOIN mCommon C on C.ID = UT.UserTypeId        
    WHERE UserName = @UserName         
    --AND Password = @EncryptPassword   
    AND U.isActive = 1              
   end  
   else  
   begin  
    SELECT UserID AS ID        
   , 2 AS UserLevel        
   , ISNULL(ResetPwdFlag,0) AS isResetPassword        
   , C.Value AS UserType         
   , 0 MainAgentBalance        
   , ISNULL(al.FirstName,'') +' '+ISNULL(al.LastName,'') AS FullName        
   , AL.BookingCountry         
   , AL.GhostTrack AS GhostTrack        
   , AL.NewSelfBalance AS NewSelfBalance        
   , '' AS 'SelfBalanceAccess' --Add Ketan Marade        
   , '' AS 'GroupId'
   ,'' AS 'NewGroupid'
   ,'' AS EmpCode        
   , R.Icast        
   , AL.UserDeviceID      
   , R.AddrEmail as EmailID      
   , '' as ParentFullName      
   ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft   
   ,AL.LastLoginDate as LastLoginDate
   ,AL.OTPRequired  
   ,(SELECT top 1 CountryCode from mCountry WITH (NOLOCK) where CountryName = AL.Country) as CountryCode    
   ,AL.SubUserEmail
   ,CASE WHEN AL.PasswordExpiryDate IS NULL THEN getDate() ELSE CONVERT(varchar(50), AL.PasswordExpiryDate, 121) END AS PasswordExpiryDate
    FROM AgentLogin AL        
    INNER JOIN mCommon C on C.ID = AL.UserTypeId        
    LEFT JOIN B2BRegistration R ON R.FKUserID = AL.UserID        
    WHERE UserName = @UserName 
	--AND Password = @Password  
	AND(AL.PasswordEncrypt IS NOT NULL AND AL.PasswordEncrypt = @EncryptPassword 
       OR AL.PasswordEncrypt IS NULL AND AL.Password = @Password)       
    AND ParentAgentID IS NULL AND AL.ISActive = 1 AND AL.AgentApproved = 1        
          
    UNION        
         
    SELECT AL.UserID AS ID        
   , 3 AS UserLevel        
   , ISNULL(AL.ResetPwdFlag,0) AS isResetPassword        
   , C.Value AS UserType, 0 MainAgentBalance        
   , ISNULL(al.FirstName,'') +' '+ISNULL(al.LastName,'') AS FullName        
   , AL.BookingCountry AS BookingCountry         
   , AL.GhostTrack AS GhostTrack,AL.NewSelfBalance AS NewSelfBalance        
   , '' AS'SelfBalanceAccess' --Add Ketan Marade        
   , '' AS 'GroupId'
   , '' AS 'NewGroupid'
   , '' AS EmpCode, R.Icast         
   , AL.UserDeviceID      
   , R.AddrEmail as EmailID      
   ,ISNULL(PAL.FirstName,'') +' '+ISNULL(PAL.LastName,'') AS ParentFullName     
    ,datediff(DAY, al.UserDeviceIdTime, getDate()) as DRDaysLeft    
    ,AL.LastLoginDate as LastLoginDate
	,AL.OTPRequired  
	,(SELECT top 1 CountryCode from mCountry WITH (NOLOCK) where CountryName = AL.Country) as CountryCode  
	,AL.SubUserEmail
    ,CASE WHEN AL.PasswordExpiryDate IS NULL THEN getDate() ELSE CONVERT(varchar(50), AL.PasswordExpiryDate, 121) END AS PasswordExpiryDate
    FROM AgentLogin AL        
    INNER JOIN mCommon C on C.ID = AL.UserTypeId        
    LEFT JOIN B2BRegistration R ON R.FKUserID = AL.ParentAgentID        
    LEFT JOIN AgentLogin as PAL on AL.ParentAgentID=PAL.UserID      
    WHERE AL.UserName = @UserName
	--AND AL.Password = @Password   
	AND(AL.PasswordEncrypt IS NOT NULL AND AL.PasswordEncrypt = @EncryptPassword 
       OR AL.PasswordEncrypt IS NULL AND AL.Password = @Password)
    AND AL.ParentAgentID IS NOT NULL        
    AND  AL.ISActive = 1 AND AL.AgentApproved = 1        
   end   
        
   IF(@UserType = 'User')        
   BEGIN        
    UPDATE mUser SET SessionID = @SessionID WHERE ID = @UserID        
        
    INSERT INTO tblLoginHistory         
       ( USERID        
       , Device        
       , IPAddress        
       , Browser        
       , Status        
       , AgencyId        
       , SessionId         
       , visitorId        
       , deviceinfo  
    , CheckBoxTime
	,RequestTimeZone
	,UserLoginCountry)        
     VALUES (@UserID        
       , @Device        
       , @IPAddress        
       , @Browser        
       , 1        
       , null        
       , @SessionID        
       , @visitorId        
       , @deviceinfo  
    , @DRCheckBoxTime
	,@RequestTimeZone
	,@UserLoginCountry)        
   END        
        
   IF(@UserType = 'Agent')        
   BEGIN        
        
    UPDATE AgentLogin        
    SET SessionID = @SessionID WHERE UserID = @UserID        
             
    INSERT INTO tblLoginHistory        
       ( USERID        
       , Device        
       , IPAddress        
       , Browser        
       , Status        
       , AgencyId        
       , SessionId        
       , visitorId        
       , deviceinfo  
    , CheckBoxTime 
    ,UserLoginCountry
	,RequestTimeZone)        
     VALUES (NULL        
       , @Device        
       , @IPAddress        
       , @Browser         
       , 1        
       , @UserID        
       , @SessionID        
       , @visitorId        
       , @deviceinfo  
    , @DRCheckBoxTime  
    , @UserLoginCountry
	,@RequestTimeZone)        
   END       
  END        
  ELSE        
  BEGIN        
   SET @IsLocked = 1        
  END        
END 