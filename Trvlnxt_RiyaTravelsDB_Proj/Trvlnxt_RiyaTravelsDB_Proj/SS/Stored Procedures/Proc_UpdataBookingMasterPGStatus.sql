create Procedure [SS].[Proc_UpdataBookingMasterPGStatus]  
@Pkid Int=0,  
@Status varchar(50)=''  
As  
Begin  
 UPDATE SS_BookingMaster Set PGStatus=@Status Where BookingId=@Pkid  
END
