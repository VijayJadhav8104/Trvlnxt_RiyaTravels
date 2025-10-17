CREATE PROC [dbo].[sp_InsertExpiredPasswordHistory]
	@UserID INT =NULL,
    @ExpiredPassword VARCHAR(500) = NULL,
		@UserName varchar(100) = Null
 AS
 BEGIN

  DECLARE @UserIDs INT =0
  IF(@UserID = 0)
  BEGIN                
        SELECT @UserIDs =UserID FROM AgentLogin WHERE UserName =@UserName  AND isActive = 1                              
  END
  ELSE
  BEGIN
    SELECT @UserIDs = @UserID
  END
       INSERT INTO tbl_ExpiredPasswordHistory(UserID,PasswordExpiryDate,ExpiredPassword)
       VALUES(@UserIDs,GETDATE(),@ExpiredPassword)
 END
      
      