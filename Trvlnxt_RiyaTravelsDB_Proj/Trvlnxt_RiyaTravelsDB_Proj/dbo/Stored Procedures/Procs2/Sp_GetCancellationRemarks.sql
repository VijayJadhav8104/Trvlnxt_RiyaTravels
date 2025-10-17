--exec Sp_GetCancellationRemarks '2GJA07'
CREATE Procedure [dbo].[Sp_GetCancellationRemarks]
@RiyaPNR nvarchar(20)
,@CancellationType varchar(50)=null
as
begin

select distinct t1.RemarkCancellation,
t2.riyaPNR


 from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
 where  t2.riyaPNR=@RiyaPNR   and (t1.BookingStatus=6 or @CancellationType='OnlineCancellation') --and t1.isReturn=0 

 end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetCancellationRemarks] TO [rt_read]
    AS [dbo];

