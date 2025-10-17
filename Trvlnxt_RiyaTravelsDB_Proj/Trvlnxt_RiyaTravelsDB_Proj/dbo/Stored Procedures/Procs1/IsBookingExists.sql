
CREATE procEDURE [dbo].[IsBookingExists] 
@RiyaPNR			varchar(20)

AS BEGIN

IF(EXISTS(SELECT 1 FROM tblBookMaster WHERE riyaPNR = @RiyaPNR))
	IF(EXISTS(SELECT 1 FROM tblBookMaster WHERE riyaPNR = @RiyaPNR and IsBooked=0))
		BEGIN
			SELECT 'FALSE'  AS IsExists
		END
	ELSE
		BEGIN
			SELECT TOP 1 'TRUE' AS IsExists, mobileNo,emailId FROM tblBookMaster WHERE riyaPNR = @RiyaPNR 
		END
ELSE
	BEGIN
	SELECT 'FALSE'  AS IsExists
	END

END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsBookingExists] TO [rt_read]
    AS [dbo];

