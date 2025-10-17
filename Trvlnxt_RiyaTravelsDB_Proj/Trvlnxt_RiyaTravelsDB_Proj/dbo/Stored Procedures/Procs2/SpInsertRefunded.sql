

CREATE proc [dbo].[SpInsertRefunded]
@riyaPNR varchar(50),
@Remark varchar(50),
@FullRefund bit=0
as
begin
update Hotel_BookMaster set IsRefunded=1,RefundedProcessRemark=@Remark,FullRefund=@FullRefund where riyaPNR=@riyaPNR
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpInsertRefunded] TO [rt_read]
    AS [dbo];

