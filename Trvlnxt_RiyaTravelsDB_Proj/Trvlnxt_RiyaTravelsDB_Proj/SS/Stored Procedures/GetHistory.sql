--[SS].[GetHistory]  312     
      
CREATE PROCEDURE [SS].[GetHistory]                         
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
  Ss.bookingUpdate_History BUH               
  left join mUser mu on BUH.InsertedBy=Mu.ID      
 -- left join ss.SS_Status_History SH on         
  where fkbookid=@Id        
          
  union         
        
  select         
  HM.Status as FieldName,        
  SH.CreateDate as InsertedDate,        
 case when SH.CreatedBy is null and SH.FkStatusId!=9  then MuA.FullName else   
 BR.AgencyName + ISNULL(+'-'+MuA.FullName,'') end as FullName        
              
  from ss.SS_BookingMaster BM        
  Left join ss.SS_Status_History SH on BM.BookingId=SH.BookingId and SH.FkStatusId!=7       
  left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id        
  left join mUser mu on SH.CreatedBy=Mu.ID     
  left join mUser MuA on BM.MainAgentID=MuA.ID    
  left join B2BRegistration BR on BM.AgentID=BR.FKUserID     
  Left join agentLogin Al on SH.CreatedBy=Al.UserID      
  where BM.BookingId=@Id       
  order by InsertedDate desc                
 End                        
                         
END 