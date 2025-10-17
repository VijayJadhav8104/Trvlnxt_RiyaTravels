
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---				[dbo].[adminLogin] '311581','rashmi@123','6','d'
CREATE PROCEDURE [dbo].[adminLogin] 
	-- Add the parameters for the stored procedure here
	@userID varchar(20),
	@passwd varchar(128),
	@IP		varchar(20),
	@Device	varchar(20),
	@SessionID VARCHAR(50)
AS
BEGIN
	----B2C@123--- 77BF29190F16FBB259E87E6A9E1510EBC6EB2C40
	IF(EXISTS(SELECT 1 FROM adminMaster where  UserName=@userID and  [Password]=@passwd))
		BEGIN
			SELECT TOP 1 Id, FullName, M.Path,
			CASE WHEN Password = '77BF29190F16FBB259E87E6A9E1510EBC6EB2C40' THEN 1 ELSE 0 END AS IsResetPassword
			From [dbo].[adminMaster] A
			JOIN  RoleAccess R ON R.UserID = A.Id
			JOIN Menu M ON R.MenuID = M.MenuID
			where  UserName=@userID and  [Password]=@passwd AND R.IsActive = 1 AND M.MenuName <> 'Reports'
			ORDER BY M.OrderID

			INSERT INTO LoginHistory(IP, Device, UserId, Status)
			VALUES(@IP,@Device,@userID,'Success')


			--Check to restrict multiple session for same user
			UPDATE adminMaster
			SET SessionID=@SessionID WHERE   UserName=@userID and  [Password]=@passwd
		END
	ELSE
	BEGIN
		INSERT INTO LoginHistory(IP, Device, UserId, Status)
			VALUES(@IP,@Device,@userID,'Failed')
	END

END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[adminLogin] TO [rt_read]
    AS [dbo];

