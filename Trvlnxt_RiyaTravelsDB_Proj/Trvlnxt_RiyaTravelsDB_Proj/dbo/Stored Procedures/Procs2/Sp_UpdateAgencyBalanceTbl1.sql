      
CREATE Procedure [dbo].[Sp_UpdateAgencyBalanceTbl1]      
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
       
declare @CountryID INT      
declare @Agencybalance decimal(18, 2)=null      
declare @AgencybalanceTotal decimal(18, 2)=null    
declare @bookingref varchar(100)=null  
declare @createdby varchar(50)=null  
      
set @CountryID=(select ID from mCountry with (nolock) where CountryCode=@countrycode)      
set @Agencybalance=(select distinct AgentBalance from mUserCountryMapping with (nolock) where UserId=@MainAgentId and CountryId=@CountryID)      
      
set @AgencybalanceTotal=@Agencybalance+@Total      

set @bookingref=(select orderId from tblBookMaster with (nolock) where riyaPNR=@PNR)   
set @createdby=(select MainAgentId from tblBookMaster with (nolock) where riyaPNR=@PNR)  
      
Update mUserCountryMapping     
set AgentBalance=@AgencybalanceTotal     
where UserId=@MainAgentId and CountryId=@CountryID    


  
insert into tblSelfBalance(UserID,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,TransactionType)    
values(@MainAgentId,@bookingref,@Agencybalance,@Total,@AgencybalanceTotal,@createdby,'Credit')        
end      
      
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateAgencyBalanceTbl1] TO [rt_read]
    AS [dbo];

