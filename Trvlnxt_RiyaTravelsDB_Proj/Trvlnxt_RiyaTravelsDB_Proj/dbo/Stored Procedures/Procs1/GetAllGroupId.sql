CREATE PROCEDURE [dbo].[GetAllGroupId]        
@IsActive bit      
,@UserType varchar(50)  
 -- Add the parameters for the stored procedure here        
         
AS        
BEGIN        
         
 select Id,GroupName,ToEmail,CcEmail from magentGroup where IsActive=@IsActive and UserType = @UserType        
END 



