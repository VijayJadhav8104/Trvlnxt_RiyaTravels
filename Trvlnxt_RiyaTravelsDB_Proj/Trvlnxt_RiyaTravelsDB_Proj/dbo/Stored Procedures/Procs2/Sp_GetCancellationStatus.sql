--exec Sp_GetCancellationStatus '5ZS951'
CREATE Procedure [dbo].[Sp_GetCancellationStatus]
@RiyaPNR nvarchar(20)=null
as
begin


--status To be cancelled
Declare @TotalPasscount int
Declare @TobeCancelledPasscount int
Declare @CancelledPasscount int

set @TotalPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@RiyaPNR) --and t1.isReturn=0)

set @TobeCancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@RiyaPNR and (t1.BookingStatus=6 or t1.BookingStatus=4 or t1.BookingStatus=11))

set @CancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=4)

if(@TotalPasscount=@TobeCancelledPasscount)
begin
select top 1 BookingStatus from tblBookMaster where riyapnr=@RiyaPNR
end

else if(@TotalPasscount=@CancelledPasscount)
begin
select top 1 BookingStatus from tblBookMaster where riyapnr=@RiyaPNR
end



end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetCancellationStatus] TO [rt_read]
    AS [dbo];

