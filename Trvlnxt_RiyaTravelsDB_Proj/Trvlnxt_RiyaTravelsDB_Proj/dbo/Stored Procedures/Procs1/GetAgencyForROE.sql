CREATE PROC GetAgencyForROE
	@AgencyID VARCHAR(50)='',@PKID VARCHAR(50)=''
AS
BEGIN
	SET NOCOUNT ON;

	IF(@AgencyID!='')
	BEGIN
		SELECT PKID, Icast,FKUserID, AgencyName,Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
		WHERE FKUserID=@AgencyID
	END
	ELSE IF(@PKID!='')
	BEGIN
		SELECT PKID, Icast,FKUserID, AgencyName,Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
		WHERE PKID=@PKID
	END
END