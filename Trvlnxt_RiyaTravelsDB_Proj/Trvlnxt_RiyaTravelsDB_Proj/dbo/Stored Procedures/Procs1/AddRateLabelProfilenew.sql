    --select * from RateLabelTest               
            
CREATE PROCEDURE AddRateLabelProfilenew                        
                         
                         
 @Rate  nvarchar(max)='',                        
                       
 @label nvarchar(500)='',                        
 @Category_N varchar(50)=null,                        
 @Category_P varchar(50)=null,                        
 @Category_B varchar(50),                        
 @AgentId int,                        
 @SupplierId int,            
 @Id int=0,            
 --@Action varchar(200),                             
 @CreatedBy int=0 ,          
 @counter int          
 --@ModifiedBy int=0                        
                        
          
             
AS                        
BEGIN                        
            declare @fkuserid int=0      
         
   select @fkuserid=FKUserID  from B2BRegistration where PKID=@AgentId      
      
     if(@counter=0)          
     begin        
    
    delete [Hotel].RateLabelNEw where AgentId=@fkuserid AND SupplierId=@SupplierId    
  
       --update [Hotel].RateLabelNEw set isActive=0  where  AgentId=@fkuserid AND SupplierId=@SupplierId            
   end          
          
  insert into [Hotel].RateLabelNEw(Rate,Label,Category_N,Category_P,Category_B,AgentId,SupplierId,CreatedBy,CreatedOn,IsActive)                         
  values(@Rate,@label,@Category_N,@Category_P,@Category_B,@fkuserid,@SupplierId,@CreatedBy,GETDATE(),1)                        
end 



