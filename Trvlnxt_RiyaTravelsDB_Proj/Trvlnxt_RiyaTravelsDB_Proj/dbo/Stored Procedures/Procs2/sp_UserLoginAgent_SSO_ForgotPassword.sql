CREATE PROCEDURE [dbo].[sp_UserLoginAgent_SSO_ForgotPassword] -- [sp_UserLoginAgent] 'manasvee@riya.travel','123456789'          
@UserName varchar(100)          
AS          
BEGIN          
  DECLARE @UserID INT, @UserType varchar(10)  
  DECLARE @LoginAttempt INT, @AttemptNo INT, @AttemptedDate Datetime       
    
  SELECT @LoginAttempt = LoginAttempt , @AttemptNo = AttemptNo , @AttemptedDate = AttemptedDate           
  FROM mUser WHERE UserName = @UserName AND isActive = 1  
  
  SET @AttemptedDate = ISNULL(@AttemptedDate, DATEADD(minute,-1,GETDATE()))          
  IF(@AttemptedDate < GETDATE() OR @LoginAttempt = 0)          
  BEGIN  
  
    SELECT @UserID = ID  FROM mUser WHERE UserName = @UserName AND isActive = 1 --AND Password = @EncryptPassword    
          
   IF(@UserID IS NULL)          
   BEGIN          
    SELECT @UserID = UserID  FROM AgentLogin WHERE UserName = @UserName AND IsActive = 1          
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
   , U.SelfBalance AS 'SelfBalanceAccess'       
   , U.GroupId AS 'GroupId'          
   , U.EmployeeNo AS EmpCode          
   , '' AS Icast          
   , U.UserDeviceID as UserDeviceID        
   , U.EmailID as EmailID        
   , '' as ParentFullName      
   ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft     
   ,U.LastLoginDate as LastLoginDate,U.OTPRequired    
    FROM mUser U          
    INNER JOIN mUserTypeMapping UT on UT.UserId = U.ID          
    INNER JOIN mCommon C on C.ID = UT.UserTypeId          
    WHERE UserName = @UserName           
    --AND Password = @EncryptPassword     
    --AND U.isActive = 1                
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
   , '' AS 'GroupId','' AS EmpCode          
   , R.Icast          
   , AL.UserDeviceID        
   , R.AddrEmail as EmailID        
   , '' as ParentFullName        
   ,datediff(DAY, UserDeviceIdTime, getDate()) as DRDaysLeft     
   ,AL.LastLoginDate as LastLoginDate,AL.OTPRequired    
    FROM AgentLogin AL          
    INNER JOIN mCommon C on C.ID = AL.UserTypeId          
    LEFT JOIN B2BRegistration R ON R.FKUserID = AL.UserID          
    WHERE UserName = @UserName  
    --AND Password = @Password           
    AND ParentAgentID IS NULL 
	--AND AL.ISActive = 1 
	AND AL.AgentApproved = 1          
            
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
    ,AL.LastLoginDate as LastLoginDate,AL.OTPRequired    
    FROM AgentLogin AL          
    INNER JOIN mCommon C on C.ID = AL.UserTypeId          
    LEFT JOIN B2BRegistration R ON R.FKUserID = AL.ParentAgentID          
    LEFT JOIN AgentLogin as PAL on AL.ParentAgentID=PAL.UserID        
    WHERE AL.UserName = @UserName   
    --AND AL.Password = @Password          
    AND AL.ParentAgentID IS NOT NULL          
    --AND  AL.ISActive = 1 
	AND AL.AgentApproved = 1          
   end  
  end  
END 