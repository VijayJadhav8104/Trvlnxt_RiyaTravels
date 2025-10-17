  
  
 Create Proc AddCancellatiobCharges  
  @BookingId varchar(50)=''  
 ,@CancelCharge varchar(50)=''  
  
 AS  
  
 BEGIN  
    update Hotel_BookMaster set AdOn_CancellationCharges=@CancelCharge Where BookingReference=@BookingId   
 END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddCancellatiobCharges] TO [rt_read]
    AS [dbo];

