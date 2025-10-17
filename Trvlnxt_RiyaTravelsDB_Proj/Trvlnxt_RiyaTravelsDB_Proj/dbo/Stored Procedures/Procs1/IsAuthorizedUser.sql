


CREATE PROCEDURE [dbo].[IsAuthorizedUser] --'1062','Booking-Process-B2C'
@UserId			int,
@Url			varchar(64)
AS BEGIN

	DECLARE @Result int
	DECLARE @MenuID int
	SELECT @MenuID = MenuID FROM Menu WHERE Path ='~/'+ @Url
	IF(EXISTS(SELECT 1 FROM RoleAccess WHERE UserID = @UserId 
	AND MenuID in (SELECT top 1 MenuID FROM Menu WHERE Path ='~/'+ @Url) AND  IsActive= 1))
		BEGIN
			SET @Result =@MenuID
		END
	ELSE
		BEGIN
			SET @Result = 0
		END
	SELECT @Result
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsAuthorizedUser] TO [rt_read]
    AS [dbo];

