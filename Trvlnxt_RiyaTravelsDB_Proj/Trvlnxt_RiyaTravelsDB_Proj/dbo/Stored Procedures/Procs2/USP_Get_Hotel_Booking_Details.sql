    
CREATE PROCEDURE  [dbo].[USP_Get_Hotel_Booking_Details]        
        
@book_Id VARCHAR(50)  =null        
        
AS                                                              
BEGIN                              
        
        
if(@book_Id!='')        
        
BEGIN        
        
Select B2BPaymentMode,SupplierRate,AgentId,AgentRate,SupplierReferenceNo,CurrentDateSchedular,HM.inserteddate,CurrentStatus,CheckInDate, HM.BookStatusSchedulerFlag,        
HM.BookingReference,HM.AlertEmail,mu.EmailID as MainAgentEmailId,BR.AddrEmail,HSM.Status as HistorStatus,*                                                          
 from Hotel_BookMaster HM         
 inner Join B2BRegistration BR ON HM.RiyaAgentID = BR.FKUserID         
 left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1        
 Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id        
 left Join mUser mu ON HM.MainAgentID=mu.ID        
 where  HM.pkId=@book_Id or HM.BookingReference=@book_Id        
        
END         
        
ELSE        
        
BEGIN        
                              
 Select B2BPaymentMode,CurrentDateSchedular,SupplierRate,AgentId,AgentRate,SupplierReferenceNo,HM.inserteddate,CurrentStatus,CheckInDate,        
 HM.BookStatusSchedulerFlag,HM.BookingReference,HM.AlertEmail,mu.EmailID as MainAgentEmailId,BR.AddrEmail,HSM.Status as HistorStatus,*                                                          
 from Hotel_BookMaster HM        
 inner Join B2BRegistration BR ON HM.RiyaAgentID = BR.FKUserID         
 left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1        
 Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id        
 left Join mUser mu ON HM.MainAgentID=mu.ID        
 where                               
                               
 HSM.Status in('On Request','Pending','InProcess')                               
             
 and datediff(minute, HM.inserteddate, GETDATE())>5      
                              
 and convert(date,HM.CheckInDate) >= convert(date,GETDATE())   
 and HM.BookingPortal='Qtech'
 and ISNULL (HM.riyaPNR,'') != ''                          
 and HM.pkId not in(                              
                              
select distinct FKHotelBookingId from Hotel_Status_History where FkStatusId=3 and IsActive=1 and FKHotelBookingId>0)          
        
END        
        
                                        
Update SchedularBookingUpdated set StartDate=GETDATE()                                    
                                 
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_Get_Hotel_Booking_Details] TO [rt_read]
    AS [dbo];

