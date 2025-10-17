CREATE FUNCTION dbo.GetItineraryDetails
(
	@OrderID Varchar(40)
	,@QueryType Varchar(20)
)
RETURNS Varchar(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar Varchar(MAX)

	IF (@QueryType = 'SECTOR')
	BEGIN
		SELECT @ResultVar = STUFF((SELECT '/' + frmSector+ '-' + toSector 
		FROM tblBookItenary WHERE orderId = @OrderID FOR XML PATH('')),1,1,'') 
	END

	-- Return the result of the function
	RETURN @ResultVar

END
