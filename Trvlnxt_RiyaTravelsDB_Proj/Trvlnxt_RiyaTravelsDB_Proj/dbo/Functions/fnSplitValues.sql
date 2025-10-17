CREATE FUNCTION [dbo].[fnSplitValues]
(
	@IDs nvarchar(max)
)
RETURNS 
@SplitValues TABLE 
(
	ID int
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	
	DECLARE @xml xml
	SET @xml = N'<root><r>' + replace(@IDs,',','</r><r>') + '</r></root>'

	INSERT INTO @SplitValues(ID)
	SELECT r.value('.','int')
	FROM @xml.nodes('//root/r') as records(r)

	RETURN
END

