CREATE PROCEDURE GetRateCodeDetails                       
 -- Add the parameters for the stored procedure here                      
 @AgentId int=0,       
 @SupplierId  int=0      
AS                      
BEGIN                      
 -- SET NOCOUNT ON added to prevent extra result sets from                      
 -- interfering with SELECT statements.  
 Declare @FKuserid int=0  
 select @FKuserid=FKuserid from B2BRegistration where PKID=@AgentId  
 SET NOCOUNT ON;                      
                      
     
Select id,Rate,      
Label,      
Category_N,      
Category_P,      
Category_B      
from [Hotel].RateLabelNEw       
where AgentId=@FKuserid and SupplierId=@SupplierId  and IsActive=1    
                    
                      
END 