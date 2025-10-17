CREATE PROCEDURE [dbo].[UpdateAddUserSelfBalance]          
@RiyaPNR VARCHAR(50)=null     
,@OrderID VARCHAR(50)=null        
,@AddUserSelfBalance VARCHAR(50)=null    
AS          
BEGIN
  UPDATE tblBookMaster          
  SET AddUserSelfBalance = @AddUserSelfBalance          
  WHERE RiyaPNR = @RiyaPNR AND OrderID = @OrderID
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateAddUserSelfBalance] TO [rt_read]
    AS [dbo];

