--[TR].[TR_TransferBBUpdateBookingStatus] '155','33435','Self Balance','','','','', '','',''      
CREATE PROCEDURE [TR].[TR_TransferBBUpdateBookingStatus]                        
 @pkId BIGINT =   null,                       
--@Bookingid varchar = null ,                     
@AgentId varchar = null,                    
@PaymentType varchar = null,                    
@Passportnumber varchar = null,                    
@IssueDate varchar = null,                    
@ExpiryDate varchar = null,                    
@PanCardNumber varchar = null,                
@MainAgentId Varchar =null,                
@B2bPayMode varchar=null,            
@SubMainAgenId varchar(20) = null            
                
                  
AS                              
BEGIN                              
 BEGIN TRY                              
  BEGIN TRANSACTION                              
                  
update TR.TR_BookingMaster set BookingStatus = 'vouchered' ,  PaymentMode= @B2bPayMode,SubMainAgntId =@SubMainAgenId                    
 WHERE BookingId = @pkId                        
                         
  UPDATE TR.TR_Status_History                              
  SET IsActive = 0                              
  WHERE BookingId = @pkId                     
                        
   INSERT INTO TR.TR_Status_History (                            
   BookingId                            
   ,FkStatusId      
   ,CreateDate    
   ,CreatedBy    
   ,ModifiedDate                            
   ,ModifiedBy                            
   ,IsActive                   
   ,MainAgentId          
   ,MethodName          
   )                            
  VALUES (                            
   @pkId                            
   ,4                            
   ,GETDATE()      
   ,'0'     
   ,GETDATE()     
   ,'0'    
   ,1                  
   ,@MainAgentId          
   ,'BBManageBooking'          
   )                           
                     
select 1 as Flag                  
                  
 COMMIT TRANSACTION                              
 END TRY                              
 BEGIN CATCH                              
  ROLLBACK TRANSACTION                              
 END CATCH                              
END 