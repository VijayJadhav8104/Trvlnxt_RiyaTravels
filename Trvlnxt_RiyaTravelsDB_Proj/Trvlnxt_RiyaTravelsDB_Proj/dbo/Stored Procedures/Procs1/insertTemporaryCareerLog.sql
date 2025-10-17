CREATE proc [dbo].[insertTemporaryCareerLog]
@MailSend bit
as
begin
		begin
			insert into tblTemporaryCareerLog 
			(MailSend)values(@MailSend)
		end
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertTemporaryCareerLog] TO [rt_read]
    AS [dbo];

