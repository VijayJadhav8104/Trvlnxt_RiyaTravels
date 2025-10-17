
CREATE PROCEDURE [dbo].[sp_Check_ICAST]	
@ICAST varchar(50)=null	
AS
BEGIN
		SELECT *
		FROM B2BRegistration
		WHERE Icast=@ICAST 
END
	
	







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_Check_ICAST] TO [rt_read]
    AS [dbo];

