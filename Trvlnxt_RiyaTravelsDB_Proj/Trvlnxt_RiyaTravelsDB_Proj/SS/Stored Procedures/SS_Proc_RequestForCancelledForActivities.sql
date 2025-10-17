Create Procedure SS.SS_Proc_RequestForCancelledForActivities  
@BookingRefId varchar(100)=null  
 
As  
Begin  
 Update SS.SS_BookingMaster Set RequestForCancelled='Yes' Where BookingRefId=@BookingRefId 
End
