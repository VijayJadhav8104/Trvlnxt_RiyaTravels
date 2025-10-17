
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FetchAllUserInfo] --1
	@ID int=0
AS
BEGIN
	SET NOCOUNT ON;
	if(@ID=0)
	BEGIN
	   SELECT Id,UserName,FullName,Password,Status,isnull(Allagents,0) as Allagents
	   FROM adminMaster where Status = 1 and UserName != 'Admin'

	   SELECT * FROM  Menu --where menuname !='Reports' 
	   ORDER BY OrderID

	 	SELECT Country FROM UserCountryMapping		
		WHERE UserID = @ID AND IsActive = 1
		
		
		select PKID,ActionName,MenuID from tblAction WHERE ISActive=1
		
	  END		
	ElSE
		BEGIN
			SELECT Id,UserName,FullName,Password,Status,isnull(Allagents,0) as Allagents
			FROM adminMaster
			WHERE Id=@ID
		
		SELECT MenuID FROM RoleAccess		
		WHERE UserID = @ID AND IsActive = 1

		SELECT Country FROM UserCountryMapping		
		WHERE UserID = @ID AND IsActive = 1
		
		select TA.PKID,T.ActionName,TA.MenuID,TA.ActionID from tblActionaccess TA
				INNER JOIN tblAction T ON T.PKID=TA.ActionID
				WHERE TA.ISActive=1 and TA.UserID = @ID

		END
		
		
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchAllUserInfo] TO [rt_read]
    AS [dbo];

