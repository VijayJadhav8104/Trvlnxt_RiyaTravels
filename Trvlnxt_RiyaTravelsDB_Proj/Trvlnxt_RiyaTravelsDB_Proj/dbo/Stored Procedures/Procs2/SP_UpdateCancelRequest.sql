CREATE procedure [dbo].[SP_UpdateCancelRequest]
@Riyapnr nvarchar(20),
@Remarks nvarchar(20),
@pid nvarchar(20),
@iStatus int=0,
@iMainAgentId int=0

as 
begin 
if exists(select t2.riyaPNR,t1.pid, t1.paxFName,t2.frmSector,t2.toSector,t1.BookingStatus
 FROM tblPassengerBookDetails t1  LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
where t2.riyaPNR=@Riyapnr and t1.BookingStatus=@iStatus)

declare @tab1 table (pid varchar(20))
insert into @tab1
select pid from tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@Riyapnr and t1.BookingStatus=@iStatus



begin
UPDATE  tblPassengerBookDetails
SET    cancellationDate=GETDATE(),RemarkCancellation3=@Remarks,bookingstatus=null,ReverseByMainAgentId=@iMainAgentId
FROM tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE t2.riyaPNR=@Riyapnr and t1.pid in(select pid from @tab1)

Update tblBookMaster  set BookingStatus=1 where riyaPNR=@Riyapnr and BookingStatus != 18
end

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_UpdateCancelRequest] TO [rt_read]
    AS [dbo];

