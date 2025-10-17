
CREATE PROC [dbo].[sp_UserLoginCheckNew] --'test@riya.travel','123','Desktop','::1','Chrome','CA',0
@UserName varchar(500),
@Password varchar(300)=null,
@opr int,
@Device VARCHAR(50)=null,
@IPAddress VARCHAR(50)=null,
@Browser VARCHAR(50)=null,
@Country VARCHAR(2)=null

AS
BEGIN
		DECLARE @Flag INT=0
		BEGIN
		IF(EXISTS(
					SELECT * 
						FROM 
							UserLogin 
							  WHERE 
								 UserName=@UserName 
								 AND 
								  Password=@Password
							)
		  )
		BEGIN
			SET @Flag=(SELECT AgentApproved
							FROM 
								UserLogin
							where
								AgentApproved=0
								AND
								UserName=@UserName
				)
			IF @Flag=0
			BEGIN
				SELECT 
					UserID,
					UserName,
					FirstName,
					LastName,
					MobileNumber,
					HomeNo,
					BookingCountry,
					isnull(IsB2BAgent,0) as IsB2BAgent,
					isnull(AgentApproved,0) as AgentApproved 
					FROM 
						UserLogin 
							WHERE 
								UserName=@UserName 
								AND 
									Password=@Password;
			
				DECLARE @UserID INT
				SELECT 
						@UserID=UserID 
						FROM 
							UserLogin 
								WHERE 
									UserName=@UserName 
									AND 
										Password=@Password;

				INSERT INTO tblLoginHistory
				(
				  USERID,
				  Device,
				  IPAddress,
				  Browser,
				  Country,
				  Status
				 )
				VALUES 
				(
				  @UserID,
				  @Device,
				  @IPAddress,
				  @Browser,
				  @Country,
				  1
				)
			END
			ELSE
			BEGIN
				SELECT 1 AS STATUS
			END
		END

		ELSE
		BEGIN
			INSERT INTO tblLoginHistory
			(
			    USERID,
				Device,
				IPAddress,
				Browser,
				Country,
				Status
			)
			VALUES 
			(
			    NULL,
				@Device,
				@IPAddress,
				@Browser,
				@Country,
				0
			)
		END

		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckNew] TO [rt_read]
    AS [dbo];

