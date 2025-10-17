CREATE Procedure [dbo].[PNR_UpdatePenaltyAndBookingStatus]      
@PNR nvarchar(50),      
@CancellationRemarks2 nvarchar(500)=null,      
@AgentID int,      
@MainAgentId int,      
@Pid nvarchar(200)=null,      
@debit decimal=null,      
@CancellationPenalty decimal=null,      
@ServiceFee decimal=null       
,@CheckboxVoid bit=null       
,@MarkupOnBaseFare decimal=null       
,@MarkupOnTaxFare decimal=null       
,@MarkuponPenalty decimal=null      
,@CancellationType varchar(50)=null      
,@StatusValue int=null  
as      
begin      
     
declare @iStatusValue int = @StatusValue   
declare @dtOpenTicketDate datetime =null
declare @dtCancelDate datetime =null


if(@iStatusValue=14)
begin
set @dtOpenTicketDate=GETDATE()
end

if(@iStatusValue=6)
begin
set @dtCancelDate=GETDATE()
end

if(@MainAgentId >0)      
begin      

      
 UPDATE  tblPassengerBookDetails      
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue,OpenTicketDate=@dtOpenTicketDate, CancelledDate=@dtCancelDate,CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare      
,debit=@debit,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID,
MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
FROM    tblPassengerBookDetails t1       
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster      
WHERE   t2.riyaPNR=@PNR  and t1.PID=@Pid --in (select DATA from sample_split(@Pid,','))       
      
update tblPassengerBookDetails      
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue,OpenTicketDate=@dtOpenTicketDate, CancelledDate=@dtCancelDate, CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare      
,debit=0,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID,
MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
where pid in(      
select pid from tblPassengerBookDetails where fkBookMaster in(       
select pkId from tblBookMaster where riyaPNR=@PNR and totalFare=0)      
 and paxtype in (select paxType  from tblPassengerBookDetails where pid=@Pid)      
 and paxFName in (select paxFName  from tblPassengerBookDetails where pid=@Pid)      
  and paxLName in (select paxLName  from tblPassengerBookDetails where pid=@Pid))      
      
Update tblBookMaster  set BookingStatus=@iStatusValue,CancelledDate=@dtCancelDate where riyaPNR=@PNR    
     
end      
else      
begin      
      
 UPDATE  tblPassengerBookDetails      
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue,OpenTicketDate=@dtOpenTicketDate, CancelledDate=@dtCancelDate,CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare      
,debit=@debit,CancelByAgency1=@AgentID,CheckboxVoid=@CheckboxVoid,CancelByBackendUser1=@MainAgentId,
MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee   
FROM    tblPassengerBookDetails t1       
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster      
WHERE   t2.riyaPNR=@PNR and t1.PID in (select DATA from sample_split(@Pid,','))       
      
update tblPassengerBookDetails      
SET     RemarkCancellation2 = @CancellationRemarks2, BookingStatus=@iStatusValue,OpenTicketDate=@dtOpenTicketDate, CancelledDate=@dtCancelDate, CancellationPenalty=@CancellationPenalty,CancellationMarkup=@MarkupOnBaseFare      
,debit=0,CancelByBackendUser1=@MainAgentId,CheckboxVoid=@CheckboxVoid,CancelByAgency1=@AgentID,
MarkupOnTaxFare=@MarkupOnTaxFare, MarkuponPenalty=@MarkuponPenalty,CancellationServiceFee= @ServiceFee  
where pid in(      
select pid from tblPassengerBookDetails where fkBookMaster in(       
select pkId from tblBookMaster where riyaPNR=@PNR and totalFare=0)      
 and paxtype in (select paxType  from tblPassengerBookDetails where pid=@Pid)      
 and paxFName in (select paxFName  from tblPassengerBookDetails where pid=@Pid)      
  and paxLName in (select paxLName  from tblPassengerBookDetails where pid=@Pid))      
      
      
Update tblBookMaster  set BookingStatus=@iStatusValue, CancelledDate = @dtCancelDate  where riyaPNR=@PNR    
    
end      
      
      
end      
      
--select * from mUser where id=3
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PNR_UpdatePenaltyAndBookingStatus] TO [rt_read]
    AS [dbo];

