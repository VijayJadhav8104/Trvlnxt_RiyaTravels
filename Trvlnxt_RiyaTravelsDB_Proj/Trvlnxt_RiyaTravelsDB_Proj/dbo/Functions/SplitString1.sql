CREATE FUNCTION dbo.SplitString1
(
    @Input NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Output TABLE (Value NVARCHAR(MAX))  -- <== 'Value' must be defined here
AS
BEGIN
    DECLARE @Start INT, @End INT
    SET @Start = 1

    WHILE CHARINDEX(@Delimiter, @Input, @Start) > 0
    BEGIN
        SET @End = CHARINDEX(@Delimiter, @Input, @Start)
        INSERT INTO @Output(Value)
        VALUES(LTRIM(RTRIM(SUBSTRING(@Input, @Start, @End - @Start))))
        SET @Start = @End + 1
    END

    INSERT INTO @Output(Value)
    VALUES(LTRIM(RTRIM(SUBSTRING(@Input, @Start, LEN(@Input) - @Start + 1))))

    RETURN
END
