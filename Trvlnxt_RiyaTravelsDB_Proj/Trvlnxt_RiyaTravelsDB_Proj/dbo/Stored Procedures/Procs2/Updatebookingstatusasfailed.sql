
create proc [dbo].[Updatebookingstatusasfailed]
 @OrderId varchar(50)

as
begin
update tblBookMaster set bookingstatus=0 where orderId=@OrderId;
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Updatebookingstatusasfailed] TO [rt_read]
    AS [dbo];

