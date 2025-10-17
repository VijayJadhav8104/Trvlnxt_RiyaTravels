      
-- =============================================      
-- Author:  AKASH SINGH      
-- Create date: 28/07/2021      
-- Description: <Description,,>      
-- SP_SelfBalReversal_HotelAction 'RT1941322' ,'','','','','','','','','GetData'      
-- =============================================      
CREATE PROCEDURE SP_SelfBalReversal_HotelAction       
 @Id varchar(20)=null,      
 @AgentInvoiceNumber varchar(50)=null,      
 @OBTCNo varchar(50)=null,      
 @InquiryNo varchar(50)=null,      
 @FileNo varchar(50)=null,      
 @PaymentRefNo varchar(50)=null,      
 @RTTRefNo varchar(50)=null,      
 @OpsRemark varchar(50)=null,      
 @AcctsRemark varchar(50)=null,       
 @Flag varchar(20)=null      
      
AS      
BEGIN      
if(@Flag='GetData')      
 begin      
    select       
     DISTINCT BookingReference 'BookingId'      
    ,CountryName      
    ,riyaPNR      
    ,HB.inserteddate      
    ,LeaderTitle 'Title'      
    ,LeaderFirstName 'Fname'      
    ,LeaderLastName 'Lname'      
    ,HP.PassengerType 'PassType'      
    ,HB.PassengerPhone 'Phone'      
    ,HB.PassengerEmail 'Email'      
    ,HB.HotelName      
    ,HB.RoomType      
    ,CheckInDate       
    ,CheckOutDate      
    ,HotelAddress1      
    ,expected_prize 'FareBasis'      
   -- ,cast((cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)) * 100)/DisplayDiscountRate  as decimal(18,3)) 'AgentMarkup'      
    ,cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,2)) 'AgentMarkup'      
    ,DisplayDiscountRate 'TotalAmount'      
    ,HM.Status      
    ,HB.orderId      
    ,case                             
    when HB.B2BPaymentMode =1 then 'Hold'                            
    when HB.B2BPaymentMode =2 then 'Credit Limit'                            
    when HB.B2BPaymentMode =3 then 'Make Payment'                            
    when HB.B2BPaymentMode =4 then 'Self Balance'                            
  end as 'PaymentMode'      
    ,DisplayDiscountRate 'MerchantAmount'      
    ,HB.SB_ReversalStatus    
 ,AL.AgentBalance    
 ,HB.MainAgentID    
 ,al.BookingCountry    
 ,HB.AgentInvoiceNumber    
 ,HB.InquiryNo    
 ,HB.FileNo    
 ,HB.PaymentRefNo    
 ,HB.OBTCNo    
 ,HB.RTTRefNo    
 ,HB.OpsRemark    
 ,HB.AcctsRemark    
    
    from      
    Hotel_BookMaster HB WITH(NOLOCK)      
    left join Hotel_Pax_master HP WITH(NOLOCK) on HB.pkId=HP.book_fk_id      
    join Hotel_Status_History SH WITH(NOLOCK) on HB.pkId=SH.FKHotelBookingId           
    INNER join Hotel_Status_Master HM WITH(NOLOCK) on SH.FkStatusId=HM.Id      
 LEFT JOIN AgentLogin AL WITH(NOLOCK) ON HB.RiyaAgentID=AL.UserID    
    where BookingReference=@Id     
 and SH.IsActive=1    
 end      
      
if(@Flag='Insert')      
 begin      
   if  exists(Select pkid from Hotel_BookMaster where SB_ReversalStatus=0 and BookingReference=@Id)      
   begin      
        update Hotel_BookMaster       
     set AgentInvoiceNumber=@AgentInvoiceNumber, OBTCNo=@OBTCNo, InquiryNo=@InquiryNo, FileNo=@FileNo,       
         PaymentRefNo=@PaymentRefNo, RTTRefNo=@RTTRefNo, OpsRemark=@OpsRemark, AcctsRemark=@AcctsRemark,      
               SB_ReversalStatus=1      
     where BookingReference=@Id      
   end      
    end      
    
--IF(@Flag='UpdateBalance')    
--begin       
--end       
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_SelfBalReversal_HotelAction] TO [rt_read]
    AS [dbo];

