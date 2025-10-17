
CREATE proc [dbo].[CMS_GetAllFAQ]
@Country varchar(100)
AS
BEGIN		
		BEGIN
			
			select Question,Answer from CMS_FAQ	where Country=@Country
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetAllFAQ] TO [rt_read]
    AS [dbo];

