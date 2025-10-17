--sp_helptext GetHistory 113028                     
CREATE PROCEDURE [dbo].[GetHistory]                                           
 -- Add the parameters for the stored procedure here                                          
 @Id int =0                                               
AS                                          
BEGIN                                          
 -- SET NOCOUNT ON added to prevent extra result sets from                                          
 -- interfering with SELECT statements.                                          
 SET NOCOUNT ON;                                          
                                          
 begin                                          
  --select SM.Status as FieldName,
  select case when SM.Status='Cancelled' then SM.Status+' '+ '('+HB.ModeOfCancellation +')'else   SM.Status end as FieldName,
 -- SH.CreateDate as InsertedDate, 
  FORMAT(CAST(SH.CreateDate AS datetime),'dd MMM yyyy hh:mm tt') as InsertedDate,
   case when Sh.MainAgentId=0 then AG.firstname else COALESCE(Mua.FullName,MU.FullName) end as FullName   
  --COALESCE(AG.firstname,MU.FullName,Mua.FullName) as FullName from                          
from  
 Hotel_bookmaster HB                          
 left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                          
--left join hotedupdatedhistory  on  HB.pkId=HH.fkbookid                          
 left join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                      
 left join mUser MUa on sh.MainAgentId=MUa.ID                          
 left join mUser mu on  Mu.ID =SH.CreatedBy                       
 left join Agentlogin AG on SH.CreatedBy=AG.UserID                          
 where HB.pkId=@Id                       
                       
 union                      
                      
 select HH.fieldname as FieldName,
 --HH.InsertedDate as InsertedDate 
FORMAT(CAST(HH.InsertedDate AS datetime),'dd MMM yyyy hh:mm tt') as InsertedDate

,IsNull(mu.FullName,'NA') as FullName  from                          
 Hotel_BookMaster HB                          
left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                          
 left join Hotel_UpdatedHistory HH  on  HB.pkId=HH.fkbookid                          
 left join mUser mu on hh.InsertedBy=Mu.ID                       
  left join Agentlogin AG on SH.CreatedBy=AG.UserID                       
where HB.pkid=@Id and FieldName in                          
 ('Pax Modified','ConfirmationNo. Added','Canx reconcilled','ServiceTime_Modified',        
 'ServiceTime_Verified','Esclation Status','ModifiedBooking','PaymentStatus','VCC Cancelation','VCC Cancelled')                          
 order by InsertedDate desc                       
 End                                          
                                           
END 