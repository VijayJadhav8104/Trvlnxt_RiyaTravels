
CREATE FUNCTION [dbo].[split_string_XML]
(
    @in_string VARCHAR(MAX),
    @delimeter VARCHAR(1)
)
RETURNS @list TABLE(tuple VARCHAR(100))
AS
BEGIN
DECLARE @sql_xml XML = Cast('<root><U>'+ Replace(@in_string, @delimeter, '</U><U>')+ '</U></root>' AS XML)
    
    INSERT INTO @list(tuple)
    SELECT f.x.value('.', 'VARCHAR(100)') AS tuple
    FROM @sql_xml.nodes('/root/U') f(x)
    WHERE f.x.value('.', 'BIGINT') <> 0
    
    RETURN 
END
