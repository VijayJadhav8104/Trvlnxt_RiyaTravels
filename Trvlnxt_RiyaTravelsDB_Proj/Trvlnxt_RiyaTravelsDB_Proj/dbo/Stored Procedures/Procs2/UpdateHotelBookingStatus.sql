


CREATE PROCEDURE UpdateHotelBookingStatus                  
@BookingPKID INT,                  
@BookingStatus VARCHAR(30) = null,                  
@FailureReason VARCHAR(MAX)=null,                  
@CurrentStatus VARCHAR(30)=null,              
@AgentId Varchar(30)=null,
@MethdName Varchar(600)=null
AS                  
BEGIN               
        
declare @statusId int=0;        
        
 UPDATE hotel_bookmaster               
 SET              
 book_message=@BookingStatus,               
 failurereason=@FailureReason,              
 CurrentStatus=@CurrentStatus               
 WHERE               
 pkId=@BookingPKID               
              
 if(@CurrentStatus ='fail' OR @CurrentStatus = 'failed')              
 begin              
 set @statusId=11        
 end         
        
  if(@CurrentStatus ='InProcess')              
 begin              
 set @statusId=9        
 end         
        
  if(@statusId !=0)      
  Begin      
        
update Hotel_Status_History set IsActive=0 where FKHotelBookingId=@BookingPKID              
              
 insert into Hotel_Status_History              
 (FKHotelBookingId,FkStatusId,CreateDate,CreatedBy,IsActive,MethodName) values              
 (@BookingPKID,@statusId,GETDATE(),@AgentId,1,@MethdName)       
  ENd      
                   
 end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateHotelBookingStatus] TO [rt_read]
    AS [dbo];

