CREATE PROC UpdatemBanner   
 @ID INT,   
 @ModifyBy INT  
  
AS      
BEGIN      
 SET NOCOUNT ON      
   
 UPDATE mBanner SET ModifiedBy=@ModifyBy,ModifiedOn=GETDATE()      
 WHERE ID=@ID   
       
END  