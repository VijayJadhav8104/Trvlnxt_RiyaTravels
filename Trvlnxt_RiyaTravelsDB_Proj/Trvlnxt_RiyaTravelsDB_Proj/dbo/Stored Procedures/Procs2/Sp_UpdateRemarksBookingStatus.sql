CREATE Procedure [dbo].[Sp_UpdateRemarksBookingStatus]  
@PNR nvarchar(50),  
@Remarks nvarchar(500)=null,  
@pid nvarchar(200)=null,  
@MainAgentId int=null,  
@AgentID int=null  
  
as  
begin  
  
if(@MainAgentId >0)  
begin  
  
 UPDATE  tblPassengerBookDetails  
SET     RemarkCancellation = @Remarks, BookingStatus=6, TobecancellationDate=GETDATE(),
CancelByBackendUser=@MainAgentId,CancelByAgency=@AgentID  ,CancelByAgency1=@AgentID  
FROM    tblPassengerBookDetails t1   
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster  
WHERE   t2.riyaPNR=@PNR and t1.PID in (select DATA from sample_split(@pid,','))   
  
update tblBookMaster set BookingStatus=6,canceledDate=getdate() where riyapnr=@PNR and BookingStatus != 18  
end  
  
else  
  
begin  
 UPDATE  tblPassengerBookDetails  
SET     RemarkCancellation = @Remarks, BookingStatus=6, TobecancellationDate=GETDATE(),
CancelByAgency=@AgentID,CancelByBackendUser=@MainAgentId  ,CancelByAgency1=@AgentID  
FROM    tblPassengerBookDetails t1   
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster  
WHERE   t2.riyaPNR=@PNR and t1.PID in (select DATA from sample_split(@pid,','))   
  
update tblBookMaster set BookingStatus=6,canceledDate=getdate()  where riyapnr=@PNR  and BookingStatus != 18
  
end  
end  
  
--select * from muser where id=3
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateRemarksBookingStatus] TO [rt_read]
    AS [dbo];

