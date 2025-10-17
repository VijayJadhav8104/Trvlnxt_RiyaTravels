CREATE Procedure [dbo].[Sp_UpdateRemarks2BookingStatus]    
@PNR nvarchar(50),    
@CancellationRemarks2 nvarchar(500)=null,    
@AgentID int,    
@MainAgentId int,    
@Pid nvarchar(200)=null,    
@debit decimal(18, 2)=null,    
@CancellationPenalty decimal(18, 2)=null,    
@ServiceFee decimal(18, 2)=null     
,@CheckboxVoid bit=null     
,@MarkupOnBaseFare decimal(18, 2)=null     
,@MarkupOnTaxFare decimal(18, 2)=null     
,@MarkuponPenalty decimal(18, 2)=null    
,@CancellationType varchar(50)=null   
,@CancellationROE decimal(18, 10)=null  
as    
begin    
    
if(@MainAgentId >0)    
begin    
 
declare @iStatusValue int = 4  
if(@CancellationType='OnlineCancellation')        
begin
        set @iStatusValue=11
end

 UPDATE  tblPassengerBookDetails    
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue, CancelledDate=GETDATE(),CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare    
,debit=@debit,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID,
MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
FROM    tblPassengerBookDetails  t1 with (nolock)    
LEFT JOIN tblBookMaster t2 with (nolock) ON t2.pkId=t1.fkBookMaster    
WHERE   t2.riyaPNR=@PNR and (t1.BookingStatus=6 or @CancellationType='OnlineCancellation') and t1.PID=@Pid --in (select DATA from sample_split(@Pid,','))     
    
update tblPassengerBookDetails    
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue, CancelledDate=GETDATE(), CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare    
,debit=0,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID
,MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
where pid in(    
select pid from tblPassengerBookDetails with (nolock) where fkBookMaster in(     
select pkId from tblBookMaster where riyaPNR=@PNR and totalFare=0)    
 and paxtype in (select paxType  from tblPassengerBookDetails with (nolock)where pid=@Pid)    
 and paxFName in (select paxFName  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
  and paxLName in (select paxLName  from tblPassengerBookDetails with (nolock) where pid=@Pid))    
    
Update tblBookMaster  set BookingStatus=@iStatusValue,CancelledDate=getdate(),CancellationROE=@CancellationROE ,Cancelledby=@MainAgentId where riyaPNR=@PNR  
--new added  
update TRVLNXT_Tickets_ERPStatus   
SET BookingStatus=@iStatusValue,CancellationPenalty=@CancellationPenalty,MarkupOnCancellation=@MarkupOnBaseFare  
,MarkupOnBaseFare = @MarkupOnBaseFare,MarkupOnTaxFare = @MarkupOnTaxFare,ServiceFee = @ServiceFee  
where riyaPNR=@PNR and PBPId=@Pid  
--new added  
update TRVLNXT_Tickets_ERPStatus   
SET BookingStatus=@iStatusValue,CancellationPenalty=@CancellationPenalty,MarkupOnCancellation=@MarkupOnBaseFare  
,MarkupOnBaseFare = @MarkupOnBaseFare,MarkupOnTaxFare = @MarkupOnTaxFare,ServiceFee = @ServiceFee  
where PBPId in(    
select pid from tblPassengerBookDetails with (nolock)where fkBookMaster in(     
select pkId from tblBookMaster with (nolock) where riyaPNR=@PNR and totalFare=0)    
 and paxtype in (select paxType  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
 and paxFName in (select paxFName  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
  and paxLName in (select paxLName  from tblPassengerBookDetails with (nolock) where pid=@Pid)) 
    
Declare @CustomerNumber nvarchar(50)    
set @CustomerNumber=(select top 1 Icast from B2BRegistration with (nolock) where FKUserID=@AgentID)    
    
Declare @BMID int    
set @BMID=(select top 1 pkId from tblBookMaster with (nolock) where riyaPNR=@PNR)    
    
Declare @Ticketnumber nvarchar(50)    
set @Ticketnumber=(select (CASE WHEN CHARINDEX('/',ticketNum)>0     
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))     
ELSE ticketNum END )as 'TicketNumber'    
from tblPassengerBookDetails where pid=@Pid)    
    
    
IF NOT EXISTS(Select 1 from TBL_ERP_RefundProcess with (nolock) where PBID=@Pid)    
    BEGIN    
    
     INSERT INTO TBL_ERP_RefundProcess     
     (BMID, PBID, CustomerNumber, TicketNumber, Canfees, ServiceFees, MarkupOnBaseFare, MarkupOnTaxFare, MarkuponPenalty,Narration, [User], CreatedDate, Flag)    
     Values    
     (@BMID, @Pid, @CustomerNumber, @Ticketnumber, @CancellationPenalty,@ServiceFee,@MarkupOnBaseFare, @MarkupOnTaxFare, @MarkuponPenalty, @CancellationRemarks2, @MainAgentId, getdate(), 'Pending')    
         
     Update tblPassengerBookDetails SET IsCreditNoteGen = 1 where pid = @Pid    
         
    END    
    
end    
else    
begin    
    
 UPDATE  tblPassengerBookDetails    
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue, CancelledDate=GETDATE(),CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare    
,debit=@debit,CancelByAgency1=@AgentID,CheckboxVoid=@CheckboxVoid,CancelByBackendUser1=@MainAgentId 
,MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
FROM    tblPassengerBookDetails t1 with (nolock)    
LEFT JOIN tblBookMaster t2 with (nolock) ON t2.pkId=t1.fkBookMaster    
WHERE   t2.riyaPNR=@PNR and (t1.BookingStatus=6 or @CancellationType='OnlineCancellation') and t1.PID in (select DATA from sample_split(@Pid,','))     
    
update tblPassengerBookDetails    
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue, CancelledDate=GETDATE(), CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare    
,debit=0,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID 
,MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
where pid in(    
select pid from tblPassengerBookDetails with (nolock) where fkBookMaster in(     
select pkId from tblBookMaster with (nolock) where riyaPNR=@PNR and totalFare=0)    
 and paxtype in (select paxType  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
 and paxFName in (select paxFName  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
  and paxLName in (select paxLName  from tblPassengerBookDetails with (nolock) where pid=@Pid))    
    
    
Update tblBookMaster  set BookingStatus=@iStatusValue, CancelledDate = getdate()  where riyaPNR=@PNR  
--new added  
update TRVLNXT_Tickets_ERPStatus   
SET BookingStatus=@iStatusValue,CancellationPenalty=@CancellationPenalty,MarkupOnCancellation=@MarkupOnBaseFare  
,MarkupOnBaseFare = @MarkupOnBaseFare,MarkupOnTaxFare = @MarkupOnTaxFare,ServiceFee = @ServiceFee  
where riyaPNR=@PNR and PBPId in (select DATA from sample_split(@Pid,','))   
--new added  
update TRVLNXT_Tickets_ERPStatus   
SET BookingStatus=@iStatusValue,CancellationPenalty=@CancellationPenalty,MarkupOnCancellation=@MarkupOnBaseFare  
,MarkupOnBaseFare = @MarkupOnBaseFare,MarkupOnTaxFare = @MarkupOnTaxFare,ServiceFee = @ServiceFee  
where PBPId in (    
select pid from tblPassengerBookDetails with (nolock) where fkBookMaster in(     
select pkId from tblBookMaster with (nolock) where riyaPNR=@PNR and totalFare=0)    
 and paxtype in (select paxType  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
 and paxFName in (select paxFName  from tblPassengerBookDetails with (nolock) where pid=@Pid)    
  and paxLName in (select paxLName  from tblPassengerBookDetails with (nolock) where pid=@Pid)) 
  
end    
    
    
end    
    
--select * from mUser where id=3
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateRemarks2BookingStatus] TO [rt_read]
    AS [dbo];

