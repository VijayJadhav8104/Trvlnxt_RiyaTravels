CREATE PROC GetAgencyDataForSpecial
	@ICUST VARCHAR(100)
AS
BEGIN
	--Select FKUserID AS AgencyID,((AgencyName + ' - ' +  Icast) + isnull( ' - ' + AddrCity,'')+'-[UAE Corporate Zero Markup]') As AgencyName 
	Select FKUserID 
	from B2BRegistration Where Icast=@ICUST
END
