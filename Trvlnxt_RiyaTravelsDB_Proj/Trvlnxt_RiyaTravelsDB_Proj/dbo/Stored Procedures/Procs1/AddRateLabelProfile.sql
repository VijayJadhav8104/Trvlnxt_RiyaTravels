  
CREATE PROCEDURE AddRateLabelProfile      
       
       
 @Rate  nvarchar(500)='',      
     
 @label nvarchar(500)='',      
 @Category_N nvarchar(50)='',      
 @Category_P nvarchar(50)='',      
 @Category_B nvarchar(50)='',      
 @AgentId int,      
 @SupplierId int,     
 @Action varchar(200),           
 @CreatedBy int=0      
 --@ModifiedBy int=0      
      
AS      
BEGIN      
       
  
      
 if(@Action='ProfileDetails')      
 begin      
  insert into RateLabelTest(Rate,Label,Category_N,Category_P,Category_B,AgentId,SupplierId,CreatedBy)       
  values(@Rate,@label,@Category_N,@Category_P,@Category_B,@AgentId,@SupplierId,@CreatedBy)      
        
 end      
      
   
      
END   


  
  