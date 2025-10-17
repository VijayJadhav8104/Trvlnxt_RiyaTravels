CREATE PROCEDURE [dbo].[BBUpdateBookingStatus]                        
 @pkId BIGINT =   null,                       
--@Bookingid varchar = null ,                     
@AgentId varchar(100) = null,                    
@PaymentType varchar = null,                    
@Passportnumber varchar = null,                    
@IssueDate varchar = null,                    
@ExpiryDate varchar = null,                    
@PanCardNumber varchar(50) = '',                
@MainAgentId varchar(100) =null,                
@B2bPayMode varchar=null,            
@SubMainAgenId varchar(20) = null,        
@DoumentsURL  varchar(700)='',                
@PanName varchar(300)=''          
                
                  
AS                              
BEGIN                              
 BEGIN TRY                              
  BEGIN TRANSACTION                              
                  
update Hotel_BookMaster set CurrentStatus = 'vouchered' , Book_Message='vouchered' , B2BPaymentMode= @B2bPayMode,SuBMainAgentID =@SubMainAgenId,        
PanCardURL=@DoumentsURL WHERE pkId = @pkId              
        
--update Hotel_BookMaster set CurrentStatus = 'vouchered' , Book_Message='vouchered' , B2BPaymentMode= @B2bPayMode,SuBMainAgentID =@SubMainAgenId WHERE pkId = @pkId                        
                         
                         
  UPDATE Hotel_Status_History                              
  SET IsActive = 0                              
  WHERE FKHotelBookingId = @pkId                     
                        
 --Update Hotel_Pax_master set Pancard=@PanCardNumber,PanCardName=@PanName where book_fk_id=@pkId --and IsLeadPax=1    
   IF ISNULL(LTRIM(RTRIM(@PanCardNumber)), '') <> ''
	BEGIN
		Update Hotel_Pax_master set Pancard=@PanCardNumber,PanCardName=@PanName where book_fk_id=@pkId
	END
        
   INSERT INTO Hotel_Status_History (                            
   FKHotelBookingId                            
   ,FkStatusId                            
   ,ModifiedDate     
   ,CreatedBy    
   ,ModifiedBy                            
   ,IsActive                   
   ,MainAgentId          
   ,MethodName          
   )                            
  VALUES (                            
   @pkId                            
   ,4                            
   ,GETDATE()     
   ,@AgentId    
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
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBUpdateBookingStatus] TO [rt_read]
    AS [dbo];

