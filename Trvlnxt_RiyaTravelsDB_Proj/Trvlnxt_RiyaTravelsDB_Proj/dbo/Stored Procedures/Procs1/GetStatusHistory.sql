              
                
--sp_helptext GetStatusHistory                
                
                
CREATE PROCEDURE GetStatusHistory                               
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
  From Hotel_Status_History SH  WITH (NOLOCK)                             
  join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                              
  where FKHotelBookingId=@Id                              
  order by SH.Id desc                              
 End                              
                              
 if(@Action='CurrentStatus')                              
 Begin                              
  select convert(varchar, SH.CreateDate, 106)as CreateDate,                              
      SM.Status,                              
      SM.Id,                            
   BM.B2BPaymentMode,                            
   BM.OBTCNo,                      
   bm.RequestForCancelled,            
   BM.RiyaAgentID as 'AgentID',              
   BM.BookingReference,               
   Isnull(Bm.PanCardURL,'NA') as declarationRequired,                
   ISnull(REPLACE(BM.PanCardURL, '/Documents/PancardDocument/', 'https://trvlnxt.com/newhotel/Documents/PancardDocument/'),'NA') AS Declaration,          
   lower(CorporatePANVerificatioStatus) as PancardStatus,    
   BM.ServiceTimeVerified,          
  Isnull(BM.HotelConfNumber,'NA') as HotelConfNumber,      
  Isnull(BM.PassengerDetailsReconfirmationRemark,'NA') as PassangerDetailsConfirmationRemark       
--  Isnull(BM.PassangerConfirmationRemark,'NA') as PassangerDetailsConfirmationRemark      
  From Hotel_Status_History SH  WITH (NOLOCK)                             
  left join Hotel_BookMaster BM WITH (NOLOCK) on BM.pkId=SH.FKHotelBookingId                            
  join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                              
  where FKHotelBookingId=@Id and IsActive=1                              
 End                              
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetStatusHistory] TO [rt_read]
    AS [dbo];

