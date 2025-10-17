              
-- EXEC[TR].[GetHistory] 86            
          
CREATE PROCEDURE [TR].[GetHistory]                                
 -- Add the parameters for the stored procedure here                                
 @Id int =0                                     
AS                                
                      
                      
BEGIN                                
 -- SET NOCOUNT ON added to prevent extra result sets from                                
 -- interfering with SELECT statements.                                
 SET NOCOUNT ON;                                
                                
 begin                                
  select distinct                    
  FieldName,                
  InsertedDate,                
 ISNULL(UPPER(FullName),'NA') as FullName                       
   from                          
  TR.TR_bookingUpdate_History QBM                      
  left join mUser mu on QBM.InsertedBy=Mu.ID              
 -- left join ss.SS_Status_History SH on                 
  where FkBookid=@Id                
                  
  union                 
                
  select                 
  HM.Status as FieldName,                
  SH.CreateDate as InsertedDate,                
  Isnull(MU.FullName,al.FirstName +''+AL.LastName)  as FullName                
                      
  from TR.TR_BookingMaster BM                
  Left join TR.TR_Status_History SH on BM.BookingId=SH.BookingId and SH.FkStatusId!=7             
  left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id             
  left join mUser mu on SH.CreatedBy=Mu.ID               
  Left join agentLogin Al on SH.CreatedBy=Al.UserID              
  where BM.BookingId=@ID     
  --AND bm.BookingStatus != 'Reject'   
  --AND bm.BookingStatus !='Cancelled'            
  order by InsertedDate desc                        
 End                                
                                 
                  
END 