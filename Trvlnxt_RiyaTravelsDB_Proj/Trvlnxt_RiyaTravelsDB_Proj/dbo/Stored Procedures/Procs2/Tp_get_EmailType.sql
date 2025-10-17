
-- [Tp_get_EmailType] 'Package',ae
CREATE PROCEDURE [dbo].[Tp_get_EmailType] --'Admin','riya@123'
	-- Add the parameters for the stored procedure here
	  @EmailType varchar(100) ,
	  @CountryId  varchar(100) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
SELECT  distinct InquiryType, ToEmailID, CCEmailID
FROM EmailConfiguration 
WHERE InquiryType=@EmailType and Country=@CountryId
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Tp_get_EmailType] TO [rt_read]
    AS [dbo];

