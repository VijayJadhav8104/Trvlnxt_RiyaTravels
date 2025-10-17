Create Procedure TR.TR_Proc_RequestForCancelledForTransfers    
@BookingRefId varchar(100)=null    
   
As    
Begin    
 Update TR.TR_BookingMaster Set RequestForCancelled='Yes' Where BookingRefId=@BookingRefId   
End  