create  Procedure [dbo].[Sp_UpdateInsAgencyBalanceTbl]  
@AgentID int,  
@PNR nvarchar(50),  
@CancellationRemarks2 nvarchar(500)=null,  
@PaymentMode nvarchar(30)=null,  
@Agencybal decimal=null,  
@Total decimal=null,  
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
set @OrderId=(select distinct orderId from tblInsBookMaster where riyaPNR=@PNR)  
  
insert into tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)   
values (@AgentID,@OrderId,@PaymentMode,@Agencybal,@Total,@Agencytotal, GETDATE(),@AgentID,1,@TransactionType,@CancellationRemarks2,'null')   
END  
  
Else if(@PaymentMode='Self Balance')
begin  
declare @CountryID INT  
declare @Agencybalance decimal=null  
declare @AgencybalanceTotal decimal=null  
 
declare @bookingref varchar(100)=null


set @CountryID=(select ID from mCountry where CountryCode=@countrycode)  

set @bookingref=(select orderId from tblBookMaster where riyaPNR=@PNR) 

set @Agencybalance=(select distinct cm.AgentBalance from tblInsBookMaster t1     left join  Paymentmaster pm on pm.order_id=t1.orderId  
    left join AgentLogin ag on ag.UserID=t1.AgentID  
    left join mUserCountryMapping cm on cm.UserId=t1.IssueBy  
    where t1.riyaPNR=@PNR and t1.IssueBy=@MainAgentId and cm.CountryId=@CountryID)  
  
set @AgencybalanceTotal=@Agencybalance+@Total  
  
Update mUserCountryMapping set AgentBalance=@AgencybalanceTotal from  
mUserCountryMapping uc  
left join tblBookMaster bm on bm.MainAgentId=uc.UserId  
 left join mCountry mc on mc.CountryCode=bm.Country  
where uc.isActive=1 and uc.UserId=@MainAgentId and CountryId=@CountryID  


insert into tblSelfBalance(UserID,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,TransactionType)  
values(@MainAgentId,@bookingref,@Agencybalance,@Total,@AgencybalanceTotal,@MainAgentId,'Credit')
  
end  
  
end  
  