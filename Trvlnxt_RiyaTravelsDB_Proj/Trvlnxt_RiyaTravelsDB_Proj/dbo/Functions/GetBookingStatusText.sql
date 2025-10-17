CREATE FUNCTION GetBookingStatusText
(
	@ID Int
)
RETURNS Varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar Varchar(50)

	SET @ResultVar = (CASE @ID WHEN 1 THEN 'Confirmed' 
			WHEN 2 THEN 'Hold' 
			WHEN 3 THEN 'Pending Ticket' 
			WHEN 4 THEN 'Cancelled' 
			WHEN 5 THEN 'Close' 
			WHEN 6 THEN 'To Be Cancelled'
			WHEN 7 THEN 'To Be Rescheduled' 
			WHEN 8 THEN 'Rescheduled'
			WHEN 9 THEN 'HoldCancel'
			WHEN 0 THEN 'Failed' 
			WHEN 11 THEN 'Cancelled'
			WHEN 13 THEN 'TJQ Pending' 
			WHEN 14 THEN 'Open Ticket'
			WHEN 15 THEN 'On Hold canceled'
		ELSE 'Failed' END)

	-- Return the result of the function
	RETURN @ResultVar

END