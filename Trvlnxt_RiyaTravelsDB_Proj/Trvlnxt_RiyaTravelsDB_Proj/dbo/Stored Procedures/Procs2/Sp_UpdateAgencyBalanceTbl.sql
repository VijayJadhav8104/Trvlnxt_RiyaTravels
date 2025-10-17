  
CREATE Procedure [dbo].[Sp_UpdateAgencyBalanceTbl]  
@AgentID int,  
@PNR nvarchar(50),  
@CancellationRemarks2 nvarchar(500)=null,  
@PaymentMode nvarchar(30)=null,  
@Agencybal decimal(18, 2)=null,  
@Total decimal(18, 2)=null,  
@Agencytotal money=null,  
@MainAgentId int,  
@countrycode nvarchar(20)=null,  
@TransactionType nvarchar(20)=null  
as  
begin  
  
IF(@PaymentMode='Check' or @PaymentMode='Credit')  
BEGIN  
Update AgentLogin set AgentBalance=@Agencytotal where  
userid=@AgentID  
  
Declare @OrderId nvarchar(50)  
set @OrderId=(select distinct orderId from tblBookMaster with (nolock) where riyaPNR=@PNR)  
  
insert into tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)   
values (@AgentID,@OrderId,@PaymentMode,@Agencybal,@Total,@Agencytotal, GETDATE(),@AgentID,1,@TransactionType,@CancellationRemarks2,'null')   
END  
  
Else if(@PaymentMode='Self Balance')
begin  
declare @CountryID INT  
declare @Agencybalance decimal(18, 2)=null  
declare @AgencybalanceTotal decimal(18, 2)=null  
 
declare @bookingref varchar(100)=null


set @CountryID=(select ID from mCountry with (nolock) where CountryCode=@countrycode)  

set @bookingref=(select orderId from tblBookMaster with (nolock) where riyaPNR=@PNR) 

set @Agencybalance=(select distinct cm.AgentBalance from tblBookMaster t1 with (nolock)
   left join  Paymentmaster pm with (nolock) on pm.order_id=t1.orderId  
    left join AgentLogin ag with (nolock) on ag.UserID=t1.AgentID  
    left join mUserCountryMapping cm with (nolock) on cm.UserId=t1.MainAgentId  
    where t1.riyaPNR=@PNR and t1.mainagentid=@MainAgentId and cm.CountryId=@CountryID)  
  
set @AgencybalanceTotal=@Agencybalance+@Total  
  
Update mUserCountryMapping set AgentBalance=@AgencybalanceTotal from  
mUserCountryMapping uc  with (nolock)
left join tblBookMaster bm with (nolock) on bm.MainAgentId=uc.UserId  
 left join mCountry mc with (nolock) on mc.CountryCode=bm.Country  
where uc.isActive=1 and uc.UserId=@MainAgentId and CountryId=@CountryID  


insert into tblSelfBalance(UserID,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,TransactionType)  
values(@MainAgentId,@bookingref,@Agencybalance,@Total,@AgencybalanceTotal,@MainAgentId,'Credit')
  
end  
  
end  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateAgencyBalanceTbl] TO [rt_read]
    AS [dbo];

