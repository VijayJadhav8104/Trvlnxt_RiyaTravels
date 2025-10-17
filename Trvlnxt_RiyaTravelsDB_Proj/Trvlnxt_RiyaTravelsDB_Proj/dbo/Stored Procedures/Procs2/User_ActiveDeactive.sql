CREATE PROCEDURE [dbo].[User_ActiveDeactive]

@ID int,
@Flag bit,
@ModifiedBy int=null
as
begin

if (@ID >0)
	begin

		IF(@Flag=1)
		BEGIN
			Update mUser SET LastLoginDate=GETDATE() Where Id=@ID
		END
		
		update mUser
		set isActive = @Flag
		, ModifiedBy = @ModifiedBy
		, ModifiedOn = GETDATE()
		where ID = @ID
	end

end
