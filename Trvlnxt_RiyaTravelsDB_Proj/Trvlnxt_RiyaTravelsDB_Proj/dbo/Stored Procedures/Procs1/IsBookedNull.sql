




CREATE procedure [dbo].[IsBookedNull]

@ID varchar(50)

as
begin

update tblBookMaster
set IsBooked= Null
where orderId=@ID


end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsBookedNull] TO [rt_read]
    AS [dbo];

