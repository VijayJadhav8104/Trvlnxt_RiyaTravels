
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertUserInfo]
	@ID int,
	@UserName varchar(50),
	@FullName varchar(50),
	@InsertedBy int,
	@MenuId		tblRoleAccess READONLY,
	@CountryName   CountryMap READONLY,
	@Action		tblActionAccess READONLY,
	@Allagents bit=null
AS
BEGIN
	--SET NOCOUNT ON;
	if(@ID=0)
		BEGIN
		   IF(NOT EXISTS(SELECT 1 FROM adminMaster WHERE UserName = @UserName and Status=1))
		   BEGIN
				DECLARE @Password		varchar(128)
			   SET @Password = '77BF29190F16FBB259E87E6A9E1510EBC6EB2C40' --B2C@123 encripted password 

			   INSERT INTO adminMaster(UserName,FullName,InsertedBy,Password,Allagents)
			   VALUES(@UserName,@FullName,@InsertedBy,@Password,@Allagents)

			   DECLARE @PKID		int
			   SET @PKID = (SELECT SCOPE_IDENTITY());

			   INSERT INTO RoleAccess(UserID,MenuID,InsertedBy)
				SELECT @PKID,MenuID,@InsertedBy FROM @MenuId


				
			   INSERT INTO UserCountryMapping(Country,UserID,InsertedBy)
				SELECT CountryID, @PKID,@InsertedBy FROM @CountryName


				INSERT INTO tblActionAccess(ActionID,MenuID,UserID,InsertedBy)
				SELECT MenuID,ActionID,@PKID,@InsertedBy FROM @Action
				
		   END

		  
		END
	ELSE
		BEGIN
			UPDATE adminMaster 
			SET UpdateDate=GETDATE(),UpdatedBy=@InsertedBy,FullName=@FullName,Allagents=@Allagents
			WHERE Id=@ID

			UPDATE  RoleAccess set IsActive= 0 WHERE UserID=@ID 

			INSERT INTO RoleAccess(UserID,MenuID,InsertedBy)
			SELECT @ID,MenuID,@InsertedBy FROM @MenuId


			UPDATE  UserCountryMapping set IsActive= 0 WHERE UserID=@ID 

			 INSERT INTO UserCountryMapping(Country,UserID,InsertedBy)
			 SELECT CountryID, @ID,@InsertedBy FROM @CountryName

			UPDATE  tblActionAccess set IsActive= 0 WHERE UserID=@ID 

			 INSERT INTO tblActionAccess(ActionID,MenuID,UserID,InsertedBy)
				SELECT MenuID,ActionID,@ID,@InsertedBy FROM @Action

		END
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertUserInfo] TO [rt_read]
    AS [dbo];

