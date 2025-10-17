CREATE procedure UpdateOnlyStatus 
              
@PKID INT,                       
@CurBookingStatus VARCHAR(40)=null, 
@UserId varchar(50)=0,
@AgentId varchar(50)=0,
@MethodName VARCHAR(30)=null         
          
AS              
BEGIN           
    
declare @statusId int=0;    
    
 UPDATE hotel_bookmaster           
 SET          
 CurrentStatus=@CurBookingStatus           
 WHERE           
 pkId=@PKID  
 
  if(@CurBookingStatus ='Vouchered')          
 begin          
 set @statusId=4    
 end 

  if(@CurBookingStatus ='Confirmed')          
 begin          
 set @statusId=3    
 end 
          
 if(@CurBookingStatus ='fail' OR @CurBookingStatus = 'failed')          
 begin          
 set @statusId=11    
 end  
 
   if(@CurBookingStatus ='Pending')          
 begin          
 set @statusId=10   
 end

    if(@CurBookingStatus ='Cancelled')          
 begin          
 set @statusId=7   
 end
    
 if(@CurBookingStatus ='InProcess')          
 begin          
 set @statusId=9    
 end     
    
  if(@statusId !=0)  
  Begin  
    
update Hotel_Status_History set IsActive=0 where FKHotelBookingId=@PKID          
          
 insert into Hotel_Status_History          
 (FKHotelBookingId,FkStatusId,CreateDate,CreatedBy,IsActive,MethodName,MainAgentId) values          
 (@PKID,@statusId,GETDATE(),@AgentId,1,@MethodName,@UserId)   
  ENd  
               
 end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateOnlyStatus] TO [rt_read]
    AS [dbo];

