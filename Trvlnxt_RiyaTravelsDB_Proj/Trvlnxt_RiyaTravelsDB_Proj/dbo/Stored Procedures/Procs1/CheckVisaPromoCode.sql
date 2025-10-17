CREATE PROC [dbo].[CheckVisaPromoCode] --CheckVisaPromoCode 'A123'   
  @promoCode NVARCHAR(20) 
AS 
  BEGIN 
      DECLARE @id INT=0 

      SELECT TOP 1 @id = id 
      FROM   tblvisapromocode 
      WHERE  promocode = @promoCode and IsActive=1

      IF ( @id != 0 ) 
        BEGIN 
            SELECT  promocode, discount 
            FROM   tblvisapromocode 
            WHERE  id = @id and IsActive=1
        END 
      ELSE 
        BEGIN 
            SELECT 'inValid' AS 'promoCode',0 AS 'discount' 
        END 
  END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckVisaPromoCode] TO [rt_read]
    AS [dbo];

