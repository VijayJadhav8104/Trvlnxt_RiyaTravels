
create proc [dbo].[Updatebookingstatusaspending]
 @OrderId varchar(50)

as
begin
update tblBookMaster set bookingstatus=3 where orderId=@OrderId;
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Updatebookingstatusaspending] TO [rt_read]
    AS [dbo];

