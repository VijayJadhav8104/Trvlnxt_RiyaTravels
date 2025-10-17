CREATE Procedure Proc_GetBookingData    
@correlationId varchar(300)    
As    
Begin    
  
  Select HB.BookingReference,HB.pkId,HB.RiyaAgentID,HSM.Status  
  from   
  Hotel_BookMaster HB  WITH (NOLOCK)  
  INNER JOIN  
  Hotel_Status_History HSH  WITH (NOLOCK) 
  On HB.pkId=HSH.FKHotelBookingId  
  Inner join   
  Hotel_Status_Master HSM  WITH (NOLOCK)  
  On HSM.Id=HSH.FkStatusId AND HSH.IsActive=1  
  where searchApiId=@correlationId    
End    