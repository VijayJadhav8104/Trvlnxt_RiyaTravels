CREATE PROCEDURE CheckIcastIsExists 
    @Icast VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 1 
    FROM b2bregistration
    WHERE Icast = @Icast;
END
