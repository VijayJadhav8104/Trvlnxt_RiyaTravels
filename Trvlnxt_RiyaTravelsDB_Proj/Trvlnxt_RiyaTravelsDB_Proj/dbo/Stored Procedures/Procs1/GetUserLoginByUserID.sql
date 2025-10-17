create PROC [dbo].[GetUserLoginByUserID]
	@UserID bigint
AS
BEGIN
	SET NOCOUNT ON ;

	Select top 1 UserID,UserName,IsSSOUser from UserLogin 
	Where UserID=@UserID
END