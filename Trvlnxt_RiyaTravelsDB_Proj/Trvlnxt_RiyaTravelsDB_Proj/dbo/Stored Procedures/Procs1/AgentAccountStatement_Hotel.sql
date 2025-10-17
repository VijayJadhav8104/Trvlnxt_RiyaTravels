--sp_helpText AgentAccountStatement_Hotel      
      
---------------------------------------------------------    
 --Execute [AgentAccountStatement_Hotel]  '01-Jul-2021', '08-Jul-2021', '', '' ,'', '', '', '' ,''    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
      
CREATE Proc [dbo].[AgentAccountStatement_Hotel]      
 --@FromDate varchar(20)=null,      
 --@ToDate varchar(20)=null,      
 --@AgentId int=0,      
 --@Country varchar(20)=null,      
 --@BranchCode  varchar(20)=null,      
 --@PaymentType int=0,      
 --@AgentTypeId int=0,       
 --@ProductType varchar(20) ---      
 @FromDate Date=null,         
 @ToDate Date=null,         
 @BranchCode varchar(40)=null,         
 @PaymentType varchar(50)=null,        
 @AgentTypeId int=null,         
 @AgentId int=null,        
 @Country varchar(10)=null,        
 @ProductType varchar(20),        
 @RiyaPNR varchar(20)=null       
      
AS       
      
BEGIN      
      
select       
    
 BR.AgencyName as 'AgencyName',      
 HB.inserteddate as 'Date/Time',      
 HB.HotelName as 'Discrtiption' ,      
 HB.riyaPNR as 'Riya PNR',      
 HB.orderId as 'hotelPnr',      
 'CreditAmt' as Credit,      
 HB.DisplayDiscountRate as Debit,      
  '1000' as 'Remaining',      
 case       
    when HB.B2BPaymentMode =1 then 'Hold'      
    when HB.B2BPaymentMode =2 then 'Credit Limit'      
    when HB.B2BPaymentMode =3 then 'Make Payment'      
    when HB.B2BPaymentMode =4 then 'Self Balance'      
 end as 'Transaction Type',      
 '' as  'Remarks Ref no.'      
from       
  Hotel_BookMaster HB  WITH (NOLOCK)       
  left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID       
  left join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID      
  left join(Select BBR.FKUserID,BBR.BranchCode,Code from mBranch MB left join B2BRegistration BBR on MB.BranchCode=BBR.BranchCode)Bcode on HB.RiyaAgentID=Bcode.FKUserID        
where       
  cast(HB.inserteddate as date) between @FromDate and @ToDate and       
 (AGL.UserTypeID = @AgentTypeId  or @AgentTypeId ='') and      
 (AGL.BookingCountry= @Country or @Country='') and      
 (Bcode.Code =@BranchCode or @BranchCode='') and      
 (HB.B2BPaymentMode=@PaymentType or @PaymentType='') and      
 (HB.RiyaAgentID=@AgentId or @AgentId='')      
    and HB.RiyaAgentID is not null         
    and HB.B2BPaymentMode is not null        
    and HB.BookingReference is not null      
       
END      
      
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AgentAccountStatement_Hotel] TO [rt_read]
    AS [dbo];

