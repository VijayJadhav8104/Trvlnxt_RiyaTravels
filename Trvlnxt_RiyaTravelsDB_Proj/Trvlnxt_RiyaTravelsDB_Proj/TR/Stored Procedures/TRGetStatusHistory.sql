                  
--sp_helptext GetStatusHistory                  
                  
  --[TR].[TRGetStatusHistory] 1,'CurrentStatus'        
CREATE PROCEDURE [TR].[TRGetStatusHistory]                           
 -- Add the parameters for the stored procedure here                                
 @Id int =0,                                
 @Action varchar(50)=''                                
AS                                
BEGIN                                
                           
 SET NOCOUNT ON;                                
                            
                                 
                                
 if(@Action='History')                                
 begin                                
  select                             
      convert(varchar, SH.CreateDate, 106)as CreateDate,                             
   --sH.CreateDate as Date,                            
      SM.Status                                
  From TR.TR_Status_History SH With(Nolock)                               
  join Hotel_Status_Master SM With(Nolock) on SH.FkStatusId=SM.Id                                
  where BookingId=@Id                                
  order by SH.Id desc                                
 End                                
                                
 if(@Action='CurrentStatus')                                
 Begin                                
  select convert(varchar, SH.CreateDate, 106)as CreateDate,                                
      SM.Status,                                
      SM.Id,  
   BM.BookingId,  
   BM.CorrelationId,  
   BM.PaymentMode,                              
   BM.OBTCNo,                        
   BM.RequestForCancelled,                 
   BM.AgentID as 'AgentID',                
   BM.BookingRefId,                 
   Isnull(Bm.DocumentURL,'NA') as declarationRequired,                  
   ISnull(REPLACE(BM.DocumentURL, '/Documents/PancardDocument/', 'http://trvlnxt.parikshan.net/hotel/Documents/PancardDocument/'),'NA') AS Declaration,              
  BM.CorporatePANVerificatioStatus,    
  BM.BookingStatus    
  --Isnull(BM.HotelConfNumber,'NA') as HotelConfNumber,        
  --Isnull(BM.PassangerDetailsReConfirmationRemark,'NA') as PassangerDetailsConfirmationRemark        
  From TR.TR_Status_History SH With(Nolock)                               
  left join  TR.TR_BookingMaster BM With(Nolock) on BM.BookingId=SH.BookingId                              
  join Hotel_Status_Master SM With(Nolock) on SH.FkStatusId=SM.Id                                
  where BM.BookingId=@Id and IsActive=1                                
 End                                
END