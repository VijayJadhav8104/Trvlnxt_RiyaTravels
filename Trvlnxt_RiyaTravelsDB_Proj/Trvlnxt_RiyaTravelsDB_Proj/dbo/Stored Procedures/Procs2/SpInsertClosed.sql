

create proc [dbo].[SpInsertClosed]
@riyaPNR varchar(50),
@Remark varchar(50)
as
begin
update Hotel_BookMaster set IsClosed=1,ClosedRemark=@Remark where riyaPNR=@riyaPNR
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpInsertClosed] TO [rt_read]
    AS [dbo];

