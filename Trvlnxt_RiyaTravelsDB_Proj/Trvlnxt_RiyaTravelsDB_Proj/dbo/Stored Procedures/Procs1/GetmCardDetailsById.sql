create PROC [dbo].[GetmCardDetailsById]
@pkid INT
AS
BEGIN
	SELECT * FROM mCardDetails WHERE pkid=@pkid AND Status=1;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetmCardDetailsById] TO [rt_read]
    AS [dbo];

