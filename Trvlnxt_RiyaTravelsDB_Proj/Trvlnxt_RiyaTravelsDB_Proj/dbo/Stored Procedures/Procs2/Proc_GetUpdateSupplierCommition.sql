CREATE Procedure Proc_GetUpdateSupplierCommition  
As  
Begin  
  Select HM.searchApiId,HM.RiyaAgentID, B2BPaymentMode,CurrentDateSchedular,HM.inserteddate,CurrentStatus,CheckInDate,HR.Response,            
 HM.BookStatusSchedulerFlag,HM.BookingReference,HM.AlertEmail,mu.EmailID as MainAgentEmailId,BR.AddrEmail,HSM.Status as HistorStatus,*                                                              
 from Hotel_BookMaster HM            
 inner Join B2BRegistration BR ON HM.RiyaAgentID = BR.FKUserID             
 left JOIN [AllAppLogs].[Dbo].HotelAPI_RequestResponsetbl HR ON HM.pkId = Hr.BookingPkId                
 left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1            
 Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id            
 left Join mUser mu ON HM.MainAgentID=mu.ID            
 where                                   
                                   
 HSM.Status in('Confirmed','Vouchered')                                   
                                                                     
 and  HM.BookingPortal='TNH'  
 and HM.inserteddate<= '2023-03-24 15:16:58.470'  
 and HM.TotalRooms >1
End  


