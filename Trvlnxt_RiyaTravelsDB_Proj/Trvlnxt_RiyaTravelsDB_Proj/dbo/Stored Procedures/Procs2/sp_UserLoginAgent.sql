
--exec sp_UserLoginAgent 'avinash','pass@123'
CREATE PROCEDURE [dbo].[sp_UserLoginAgent]  -- [sp_UserLoginAgent] 'manasvee@riya.travel','123456789'
@UserName varchar(100),
@Password varchar(200),
@Device VARCHAR(50)=NULL,
@IPAddress VARCHAR(50)=NULL,
@Browser VARCHAR(50)=NULL,
@SessionID VARCHAR(50)=NULL,
@EncryptPassword varchar(200)=null,
@visitorId varchar(max)=null,
@deviceinfo varchar(max)=null,
@CheckPassword bit=1

AS
BEGIN
		declare @UserID INT,
		@UserType varchar(10)
		
		SELECT @UserID=ID  from mUser where UserName=@UserName AND Password=@EncryptPassword and isActive=1
			if(@UserID IS NULL)
			BEGIN
				SELECT @UserID=UserID  FROM AgentLogin where UserName=@UserName AND Password=@Password and IsActive=1
				set @UserType='Agent'
			END
			ELSE
			begin
				set @UserType='User'
			end

			if(@UserID IS NULL)
			begin
				set @UserType=''
			end

		SELECT U.ID ,1 AS UserLevel,isResetPassword, C.Value as UserType, U.AgentBalance as MainAgentBalance,u.FullName ,'' as BookingCountry ,U.GhostTrack as GhostTrack,U.NewSelfBalance as NewSelfBalance
		,U.SelfBalance as 'SelfBalanceAccess' --Add Ketan Marade
		,U.GroupId as 'GroupId',U.EmployeeNo AS EmpCode
		FROM mUser U
		INNER JOIN mUserTypeMapping UT on UT.UserId=U.ID
		INNER JOIN mCommon C on C.ID=UT.UserTypeId
		where UserName=@UserName AND Password=@EncryptPassword and U.isActive=1

		UNION
		SELECT UserID AS ID,2 AS UserLevel,isnull(ResetPwdFlag,0) as isResetPassword,C.Value 
        as UserType ,0 MainAgentBalance,al.FirstName +' '+al.LastName as FullName,AL.BookingCountry  ,AL.GhostTrack as GhostTrack,AL.NewSelfBalance as NewSelfBalance
		,'' as 'SelfBalanceAccess' --Add Ketan Marade
		,'' as 'GroupId','' AS EmpCode
		FROM AgentLogin AL
		INNER JOIN mCommon C on C.ID=AL.UserTypeId
		where UserName=@UserName AND Password=@Password 
		and ParentAgentID is null	AND AL.ISActive=1 AND AL.AgentApproved = 1
		
		UNION
	
	SELECT UserID AS ID,3 AS UserLevel,isnull(ResetPwdFlag,0) as isResetPassword,C.Value as UserType, 0 MainAgentBalance,al.FirstName +' '+al.LastName as FullName, AL.BookingCountry as BookingCountry  ,AL.GhostTrack as GhostTrack,AL.NewSelfBalance as NewSelfBalance
	,'' as'SelfBalanceAccess' --Add Ketan Marade
	,'' as 'GroupId','' AS EmpCode
	FROM AgentLogin AL

		INNER JOIN mCommon C on C.ID=AL.UserTypeId
		where UserName=@UserName AND Password=@Password
		and ParentAgentID is not null
		and  AL.ISActive=1 AND AL.AgentApproved = 1


				if(@UserType='User')
				begin
					UPDATE mUser SET SessionID=@SessionID WHERE ID=@UserID

					INSERT INTO tblLoginHistory 
					(USERID,Device,IPAddress,Browser,Status,AgencyId,SessionId,visitorId,deviceinfo)
					VALUES (@UserID,@Device,@IPAddress,@Browser,1,null,@SessionID,@visitorId,@deviceinfo)
				end

				if(@UserType='Agent')
				begin

					UPDATE AgentLogin
					SET SessionID=@SessionID WHERE UserID=@UserID
					
					INSERT INTO tblLoginHistory
						(USERID,Device,IPAddress,Browser,Status,AgencyId,SessionId,visitorId,deviceinfo)
						VALUES (null,@Device,@IPAddress,@Browser,1,@UserID,@SessionID,@visitorId,@deviceinfo)
				end
		
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginAgent] TO [rt_read]
    AS [dbo];

