CREATE PROCEDURE [dbo].[CrypticPNRRetrivewithLastName] --'BOMI22114','AMADEUS','51366','PINTO',''
	@officeId varchar(20)
	,@vendorName varchar(10)
	,@AgentId varchar(10)
	,@lastName varchar(150)
	,@firstName varchar(100)
AS 
BEGIN
	
	SELECT DISTINCT 
	p.paxLName+'/'+ p.paxFName as 'PAXName'
	,p.title
	,b.airCode
	,b.flightNo
	,left(c.cabin,1) as 'Class'
	,CONVERT(varchar(6),b.depDate,106) as DepDate
	,b.frmSector+b.toSector as 'sector'
	,(select count(*) from tblPassengerBookDetails where fkBookMaster=b.pkid) as 'PassangeCount'
	,b.GDSPNR 
	FROM tblBookMaster b 
	INNER JOIN tblBookItenary c on b.pkId=c.fkBookMaster
	INNER JOIN tblPassengerBookDetails p on b.pkid=p.fkbookmaster 
	WHERE (BookingSource = 'Cryptic' OR BookingSource = 'Web') 
	AND paxLName LIKE '%'+@lastName+'%' 
	AND (paxFName LIKE '%'+@firstName+'%' OR @firstName = '')
	AND vendorname = @vendorName
	AND b.OfficeID = @officeId 
	AND isReturn=0  
	AND b.AgentID = @AgentId  
	AND paxType !='INFANT' 
	AND paxType !='INF' 
	AND paxType!='CHILD' 
	AND paxType!='CHD'

	SELECT DISTINCT PAXLastName+'/'+ PAXFirstName as 'PAXName'
	,Title as title
	,AirCode as airCode
	,FlightNo as flightNo
	,LEFT(CabinClass,1) as 'Class'
	,CONVERT(varchar(6),DeptureDate,106) as DepDate
	,FromSector + ToSector as 'sector'
	,(select count(*) from tblCrypticPassengerdata where GDSPNR=GDSPNR) as 'PassangeCount'
	,GDSPNR 
	FROM tblCrypticPassengerdata 
	WHERE PAXLastName = @lastName 
	AND (PAXFirstName = @firstName OR @firstName = '')
	AND OfficeID = @officeId  
	AND AgentID = @AgentId  
	AND PAXType !='INFANT' 
	AND PAXType !='INF' 
	AND PAXType!='CHILD' 
	AND PAXType !='CHD'

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CrypticPNRRetrivewithLastName] TO [rt_read]
    AS [dbo];

