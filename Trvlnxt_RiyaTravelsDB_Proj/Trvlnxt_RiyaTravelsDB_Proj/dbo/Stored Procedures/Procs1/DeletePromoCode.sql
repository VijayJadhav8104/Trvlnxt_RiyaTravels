

CREATE PROCEDURE [dbo].[DeletePromoCode]
	-- Add the parameters for the stored procedure here
	@PKID BIGINT,
	@UserID BIGINT
AS
BEGIN--1

UPDATE [dbo].PromoCode set  IsActive=0,modifiedDate=getdate(),ModifiedBy = @UserID
WHERE Pk_Id=@PKID
	 
SELECT 1
			
END--1







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeletePromoCode] TO [rt_read]
    AS [dbo];

