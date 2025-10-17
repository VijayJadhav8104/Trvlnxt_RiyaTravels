CREATE Procedure [dbo].[USP_Get_CancellTicket_Transfer_Data]                                                           
AS                                                          
BEGIN                                                          
                                                                             
		SELECT  
				BookingRate,CancellationDeadLine,AG.UserTypeID,                                       
				BR.AddrEmail as    MainAgentEmailId,                                      
				HB.*                                                      
				,BR.*                                                      
		FROM 
				TR.TR_BookingMaster HB                                                      
				INNER JOIN B2BRegistration BR ON HB.AgentID = BR.FKUserID                                        
				left JOIN TR.TR_Status_History hsh on hsh.BookingId=HB.BookingId and hsh.IsActive=1                                      
				Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id                                      
				left Join mUser ON hb.MainAgentID=mUser.ID               
				left Join agentLogin AG On AG.UserID=HB.AgentID               
		WHERE 
				HB.PaymentMode = 1                                                      
				AND HSM.Status in('Confirmed')                                                 
				and HB.TripStartDate>=GETDATE()                                       
				and convert(datetime,Dest_CancellationDateTime,103) <=getdate()                                             
				and Dest_CancellationDateTime is not null and Dest_CancellationDateTime!=''                            
				AND HB.BookingId NOT IN ( SELECT fk_pkid  FROM UserCancelledTicket_Data)                                               
				ORDER BY HB.BookingId desc                                                      
                                                       
--select * from Hotel_BookMaster where B2BPaymentMode=1 and book_message ='vouchered'                                                           
--BookingReference,CancellationDeadLine,CancelHours,inserteddate,                                                          
END 