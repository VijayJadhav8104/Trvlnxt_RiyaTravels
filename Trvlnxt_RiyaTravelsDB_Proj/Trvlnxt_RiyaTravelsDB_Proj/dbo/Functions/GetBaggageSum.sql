CREATE FUNCTION [dbo].[GetBaggageSum]
(
  @Val1 VARCHAR(256)
  , @Val2 VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
	DECLARE @intAlpha1 INT
	DECLARE @intAlpha2 INT

	SET @intAlpha1 = PATINDEX('%[^0-9]%', @Val1)
	SET @intAlpha2 = PATINDEX('%[^0-9]%', @Val2)
  
	IF(@intAlpha1 >= 0 AND @intAlpha2 >= 0)
	BEGIN
		SET @intAlpha1 = @intAlpha1 + @intAlpha2
	END

	RETURN ISNULL(@intAlpha1,0)
END
