CREATE	 PROC [dbo].[UserLoginAgent]--'313374','40BD001563085FC35165329EA1FF5C5ECBDBBEEF'
@UserName varchar(500),
@Password varchar(300)=null,
@Device VARCHAR(50)=null,
@IPAddress VARCHAR(50)=null,
@Browser VARCHAR(50)=null,
@Country VARCHAR(2)=null,
@SessionID VARCHAR(50)= null,
@EncryptPass varchar(300)=null

AS
BEGIN
		DECLARE @Flag INT=0
		BEGIN

		IF (@Password!='NA')
		BEGIN
		IF(EXISTS(SELECT * FROM AgentLogin WHERE UserName=@UserName AND Password=@Password AND IsB2BAgent=1))
		BEGIN
			
			BEGIN
		
		--SELECT UserID,UserName,FirstName,LastName,MobileNumber,HomeNo,CASE( AgentLogin.Country) WHEN 'USA' THEN 'US' ELSE 'CA' END as BookingCountry,
				--isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved, B2BRegistration.PKID AS  BalanceID,Icast
				--FROM AgentLogin 
				--LEFT JOIN B2BRegistration ON B2BRegistration.FKUserID = UserID
				
				SELECT  UserID,UserName,FirstName,LastName,MobileNumber,HomeNo,CASE(A.Country) WHEN 'USA' THEN 'US' WHEN 'UAE' THEN 'AE' WHEN 'Marine' THEN 'MN' ELSE 'CA' END as BookingCountry,
				isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved, B2BRegistration.PKID AS  BalanceID,Icast,ResetPwdFlag,ParentAgentID,AgencyName,
				B2BRegistration.Status as B2BStatus,a.AccessFlag,AutoTicketing,IssueTicket,B2BRegistration.AmadeusCrypticCmd,B2BRegistration.SaberCrypticCmd				FROM AgentLogin  A
				LEFT JOIN B2BRegistration  ON B2BRegistration.FKUserID = UserID or B2BRegistration.FKUserID = A.ParentAgentID
				WHERE UserName=@UserName AND Password=@Password and  IsActive = 1
		
							
				DECLARE @UserID INT
				SELECT @UserID=UserID,@Country=BookingCountry FROM AgentLogin WHERE UserName=@UserName AND Password=@Password AND  IsActive = 1;

				UPDATE AgentLogin
				SET SessionID=@SessionID WHERE UserName=@UserName

				INSERT INTO tblLoginHistory
				(USERID,Device,IPAddress,Browser,Country,Status)
				VALUES (@UserID,@Device,@IPAddress,@Browser,@Country,1)
			END
			
		END
		ELSE
		BEGIN
			INSERT INTO tblLoginHistory
			(USERID,Device,IPAddress,Browser,Country,Status)
			VALUES (NULL,@Device,@IPAddress,@Browser,@Country,0)
		END
		END
		ELSE
		BEGIN

		SELECT  UserID,UserName,FirstName,LastName,MobileNumber,HomeNo,CASE(A.Country) WHEN 'USA' THEN 'US' WHEN 'UAE' THEN 'AE' WHEN 'Marine' THEN 'MN' ELSE 'CA' END as BookingCountry,
	
			isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved, B2BRegistration.PKID AS  BalanceID,Icast,ResetPwdFlag,ParentAgentID,AgencyName,
				B2BRegistration.Status as B2BStatus,a.AccessFlag,AutoTicketing,IssueTicket,B2BRegistration.AmadeusCrypticCmd,B2BRegistration.SaberCrypticCmd				
				FROM AgentLogin  A
				LEFT JOIN B2BRegistration  ON B2BRegistration.FKUserID = UserID or B2BRegistration.FKUserID = A.ParentAgentID
				WHERE UserName=@UserName and  IsActive = 1
		
							
			
				SELECT @UserID=UserID,@Country=BookingCountry FROM AgentLogin WHERE UserName=@UserName AND  IsActive = 1;

				UPDATE AgentLogin
				SET SessionID=@SessionID WHERE UserName=@UserName

				INSERT INTO tblLoginHistory
				(USERID,Device,IPAddress,Browser,Country,Status)
				VALUES (@UserID,@Device,@IPAddress,@Browser,@Country,1)
		END

		SELECT  UserName,Password,Allagents,UCM.Country
		FROM adminMaster  A
		INNER JOIN UserCountryMapping ucm on ucm.UserID=a.Id
		WHERE UserName=@UserName AND Password=@EncryptPass AND A.status = 1 and Allagents=1 AND UCM.IsActive=1

		END
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UserLoginAgent] TO [rt_read]
    AS [dbo];

