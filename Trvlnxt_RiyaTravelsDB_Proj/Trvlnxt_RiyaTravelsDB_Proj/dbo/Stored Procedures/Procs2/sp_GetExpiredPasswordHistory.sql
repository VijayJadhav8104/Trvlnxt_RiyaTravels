CREATE PROC [dbo].[sp_GetExpiredPasswordHistory]
	@UserID INT = 0,
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
  SELECT top 3 ExpiredPassword FROM tbl_ExpiredPasswordHistory WHERE UserID =@UserIDs order by PasswordExpiryDate desc
 END
      
      