--'Sibi', 'B2BAE@123', 'Desktop', '::1', 'Chrome', 'e4gberclo3mdbz0ojeovob5f', 'Bz53xZgyF6s*plus*3sF0OPs2KOZKDgRhxHlWrRFm7O4n54M=', NULL, 'os.name = Windows,os.version = 10,browser.name = Chrome,browser.version = 116,,navigator.userAgent = Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36,navigator.appVersion = 5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36,navigator.platform = Win32,navigator.vendor = Google Inc.,', NULL, NULL, 0
CREATE PROCEDURE [dbo].[sp_UserLoginAgent_Duplicate] -- [sp_UserLoginAgent] 'manasvee@riya.travel','123456789'      
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
@IsLocked INT OUTPUT      
      
AS      
BEGIN      
  DECLARE @UserID INT, @UserType varchar(10)       
  SET @IsLocked = 0      
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
    SELECT @UserID = ID  FROM mUser WHERE UserName = @UserName AND Password = @EncryptPassword AND isActive = 1      
   END      
      
   IF(@UserID IS NULL)      
   BEGIN      
    SELECT @UserID = UserID  FROM AgentLogin WHERE UserName = @UserName AND Password = @Password AND IsActive = 1      
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
     , U.EmployeeNo AS EmpCode      
     , '' AS Icast      
  , U.UserDeviceID as UserDeviceID    
  , U.EmailID as EmailID    
  , '' as ParentFullName  
  ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft  
   FROM mUser U      
   INNER JOIN mUserTypeMapping UT on UT.UserId = U.ID      
   INNER JOIN mCommon C on C.ID = UT.UserTypeId      
   WHERE UserName = @UserName       
   AND Password = @EncryptPassword AND U.isActive = 1      
      
   UNION      
      
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
     , '' AS 'GroupId','' AS EmpCode      
     , R.Icast      
  , AL.UserDeviceID    
  , R.AddrEmail as EmailID    
  , '' as ParentFullName    
  ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft  
   FROM AgentLogin AL      
   INNER JOIN mCommon C on C.ID = AL.UserTypeId      
   LEFT JOIN B2BRegistration R ON R.FKUserID = AL.UserID      
   WHERE UserName = @UserName AND Password = @Password       
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
     , '' AS EmpCode, R.Icast       
  , AL.UserDeviceID    
  , R.AddrEmail as EmailID    
  ,ISNULL(PAL.FirstName,'') +' '+ISNULL(PAL.LastName,'') AS ParentFullName   
   ,datediff(DAY, al.UserDeviceIdTime, getDate()) as DRDaysLeft  
   FROM AgentLogin AL      
   INNER JOIN mCommon C on C.ID = AL.UserTypeId      
   LEFT JOIN B2BRegistration R ON R.FKUserID = AL.ParentAgentID      
   LEFT JOIN AgentLogin as PAL on AL.ParentAgentID=PAL.UserID    
   WHERE AL.UserName = @UserName AND AL.Password = @Password      
   AND AL.ParentAgentID IS NOT NULL      
   AND  AL.ISActive = 1 AND AL.AgentApproved = 1      
      
      
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
	   , CheckBoxTime)      
     VALUES (@UserID      
       , @Device      
       , @IPAddress      
       , @Browser      
       , 1      
       , null      
       , @SessionID      
       , @visitorId      
       , @deviceinfo
	   , @DRCheckBoxTime)      
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
	   ,UserLoginCountry)      
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
	   , @UserLoginCountry)      
   END     
  END      
  ELSE      
  BEGIN      
   SET @IsLocked = 1      
  END      
END 
