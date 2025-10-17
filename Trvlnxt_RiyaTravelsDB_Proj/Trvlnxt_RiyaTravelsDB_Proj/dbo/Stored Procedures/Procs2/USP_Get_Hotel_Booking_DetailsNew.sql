--USP_Get_Hotel_Booking_DetailsNew'166578'       
     
CREATE PROCEDURE  USP_Get_Hotel_Booking_DetailsNew                       
                        
@book_Id VARCHAR(50)  =null                        
                        
AS                                                                              
BEGIN                                              
                        
                        
if(@book_Id!='')                        
                        
BEGIN                        
                        
Select HM.searchApiId,HM.RiyaAgentID, B2BPaymentMode,CurrentDateSchedular,HM.inserteddate,CurrentStatus,CheckInDate,HR.Response, HM.BookStatusSchedulerFlag,                        
HM.BookingReference,HM.AlertEmail,mu.EmailID as MainAgentEmailId,BR.AddrEmail,isnull(HM.SuBMainAgentID,0) as SuBMainAgentID,HSM.Status as HistorStatus,AG.userTypeID,    
Isnull(case when isnull(abd.Value,'')='' then null else abd.Value end,'') as 'HGToken',    
 Isnull(case when isnull(AGM.PCC,'')='' then  null else AGM.PCC end,'')  as officeId,*                                                                          
 from Hotel_BookMaster HM  WITH(Nolock)                       
 inner Join B2BRegistration BR WITH(Nolock) ON HM.RiyaAgentID = BR.FKUserID                         
 left JOIN [AllAppLogs].[Dbo].HotelAPI_RequestResponsetbl HR ON HM.pkId = Hr.BookingPkId                         
 left JOIN Hotel_Status_History hsh WITH(Nolock) on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1                        
 Left JOIN Hotel_Status_Master HSM WITH(Nolock) on hsh.FkStatusId=HSM.Id                        
 left Join mUser mu WITH(Nolock) ON HM.MainAgentID=mu.ID         
 left Join agentLogin AG WITH(Nolock) On AG.UserID=HM.RiyaAgentID       
  left  join b2bregistration b WITH(Nolock) on b.FKUserID=HM.RiyaAgentID    
 left join hotel.ApiBookData  abd WITH(Nolock) on HM.BookingReference= abd.BookingId and [Key]='HGToken'    
 left join AgentSupplierProfileMapper  AGM WITH(Nolock) on AGM.AgentId=b.PKID    and AGM.SupplierId=HM.SupplierPkId    
 where  HM.pkId=@book_Id or HM.BookingReference=@book_Id                   
 and  HM.BookingPortal='TNH'                  
                        
END                         
                        
ELSE                        
                        
BEGIN                        
                                              
 Select HM.searchApiId,HM.RiyaAgentID, B2BPaymentMode,CurrentDateSchedular,HM.inserteddate,CurrentStatus,CheckInDate,HR.Response,                        
 HM.BookStatusSchedulerFlag,HM.BookingReference,HM.AlertEmail,mu.EmailID as MainAgentEmailId,BR.AddrEmail,isnull(HM.SuBMainAgentID,0) as SuBMainAgentID,HSM.Status as HistorStatus,AG.userTypeID,    
 Isnull(case when isnull(abd.Value,'')='' then null else abd.Value end,'') as 'HGToken',    
 Isnull(case when isnull(AGM.PCC,'')='' then  null else AGM.PCC end,'')  as officeId,*                                                                 
             
 from Hotel_BookMaster HM WITH(Nolock)                        
 inner Join B2BRegistration BR WITH(Nolock) ON HM.RiyaAgentID = BR.FKUserID                         
 left JOIN [AllAppLogs].[Dbo].HotelAPI_RequestResponsetbl HR ON HM.pkId = Hr.BookingPkId                            
 left JOIN Hotel_Status_History hsh WITH(Nolock) on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1                        
 Left JOIN Hotel_Status_Master HSM WITH(Nolock) on hsh.FkStatusId=HSM.Id                        
 left Join mUser mu WITH(Nolock) ON HM.MainAgentID=mu.ID          
 left Join agentLogin AG WITH(Nolock) On AG.UserID=HM.RiyaAgentID     
 left  join b2bregistration b WITH(Nolock) on b.FKUserID=HM.RiyaAgentID    
 left join hotel.ApiBookData  abd WITH(Nolock) on HM.BookingReference= abd.BookingId and [Key]='HGToken'    
 left join AgentSupplierProfileMapper  AGM WITH(Nolock) on AGM.AgentId=b.PKID    and AGM.SupplierId=HM.SupplierPkId     
 where                                               
                      
 HSM.Status in('Pending','InProcess','')                                               
                                                   
 and datediff(minute, HM.inserteddate, GETDATE())>5                                            
 and convert(date,HM.CheckInDate) >= convert(date,GETDATE())                   
 and  (HM.BookingPortal='TNH' or HM.BookingPortal='TNHAPI')     
 --and  (HM.BookingPortal='TNH')  
 --AND HM.BookingReference='TNHAPI00159344'
 AND datediff(DAY, HM.inserteddate, GETDATE()) < 5    
 and HM.pkId not in(                                              
                                              
select distinct FKHotelBookingId from Hotel_Status_History where FkStatusId=3 and IsActive=1 and FKHotelBookingId>0)                         
                        
END                        
                        
                                                        
Update SchedularBookingUpdated set StartDate=GETDATE()                                                    
                                                 
END 