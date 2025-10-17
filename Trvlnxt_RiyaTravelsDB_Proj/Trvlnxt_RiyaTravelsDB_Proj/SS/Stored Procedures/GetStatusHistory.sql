    
    
    --exec [SS].[GetStatusHistory] 1155,'CurrentStatus'
CREATE PROCEDURE [SS].[GetStatusHistory]                 
 -- Add the parameters for the stored procedure here                
 @Id int =0,                
 @Action varchar(50)=''                
AS                
BEGIN                
 -- SET NOCOUNT ON added to prevent extra result sets from                
 -- interfering with SELECT statements.                
 SET NOCOUNT ON;                
                
    -- Insert statements for procedure here                
                 
                
 if(@Action='History')                
 begin                
  select             
      convert(varchar, SH.CreateDate, 106)as CreateDate,             
   --sH.CreateDate as Date,            
      SM.Status                
  From SS.SS_Status_History SH                
  join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                
  where SH.BookingId=@Id                
  order by SH.Id desc                
 End                
                
 if(@Action='CurrentStatus')                
 Begin                
  select convert(varchar, SH.CreateDate, 106)as CreateDate,                
      SM.Status,                
      SM.Id,              
   BM.PaymentMode,              
   BM.OBTCNumber,        
   BM.Pendingcancellation,  
   Isnull(BM.DocumentURL,'NA') as 'PancardUrl'  
  From Ss.SS_Status_History SH                
  left join SS.SS_BookingMaster BM on BM.BookingId=SH.BookingId              
  join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                
  where SH.BookingId =@Id and SH.IsActive=1                
 End                
END 