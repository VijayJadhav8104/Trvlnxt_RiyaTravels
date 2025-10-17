

CREATE procedure [dbo].[SP_UpdateRescheduleRequest]
@Riyapnr nvarchar(20),
@Remarks nvarchar(20),
@pid nvarchar(20)

as 
begin 
--if exists(select t2.riyaPNR,t1.pid, t1.paxFName,t2.frmSector,t2.toSector,t1.BookingStatus
-- FROM tblPassengerBookDetails t1  LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
--where t2.riyaPNR=@Riyapnr and t1.BookingStatus=7)

If exists(select 1 FROM tblPassengerBookDetails t1  LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster where t2.riyaPNR=@Riyapnr and t2.BookingStatus=1)

	declare @tab1 table (pid varchar(20))
	declare @ResIdTab table (pid varchar(20))

	insert into @tab1	select t1.pid from tblPassengerBookDetails t1 
	LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
	LEFT JOIN RescheduleData rd on t1.pid=rd.Pid 
	WHERE  t2.riyaPNR=@Riyapnr and rd.Status=7
	--WHERE   t2.riyaPNR=@Riyapnr and t1.BookingStatus=7

	insert into @ResIdTab	select rd.Id from RescheduleData rd 
			WHERE  riyaPNR=@Riyapnr and rd.Status=7 order by CreatedDate desc

		Begin
			UPDATE  tblPassengerBookDetails	SET  RescheduleDate=GETDATE(), RescheduleRemarks=@Remarks, bookingstatus = null
			FROM tblPassengerBookDetails t1  LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
			WHERE t2.riyaPNR=@Riyapnr and t1.pid in (select pid from @tab1)
			

			--Status 21 means Reschedule Cancelled
			Update RescheduleData set status=21 where  riyaPNR=@Riyapnr and Status=7 and ID in (select  ID from @ResIdTab)

			Update tblBookMaster  set BookingStatus=1 where riyaPNR=@Riyapnr
		End

End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_UpdateRescheduleRequest] TO [rt_read]
    AS [dbo];

