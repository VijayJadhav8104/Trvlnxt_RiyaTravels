



CREATE proc [dbo].[Agent_ActiveDeactive_Deal]

@ID int,
@Flag bit

as
begin


update Flight_Deal
set Flag = @Flag
where ID = @ID

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactive_Deal] TO [rt_read]
    AS [dbo];

