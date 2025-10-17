-- =============================================
-- Author:		Bhavika kawa
-- Description:	Airlines Booked Report
-- =============================================
--EXEC [dbo].[Sp_GetAirlinesBookedReport] '2023-07-20','2023-07-20','6E','','IN',1
CREATE PROCEDURE [dbo].[Sp_GetAirlinesBookedReport]
	@FromDate Date=null, 
	@ToDate Date=null, 
	@AirlineCode varchar(10)=null,
	@BranchCode varchar(40)=null, 
	@Country varchar(10)=null,
	@Status int=null
AS
BEGIN
	SELECT 
	(pb.paxFName +' '+pb.paxLName) AS 'Name As Per Passport'
	, pb.passportNum AS 'Ppt No.'
	, pb.dateOfBirth AS 'DOB'
	, c.Currency AS 'Currency'
	, (ISNULL(pb.totalFare,0)+ISNULL(pb.Markup,0)-(ISNULL(pb.IATACommission,0)+
		ISNULL(pb.PLBCommission,0)+ISNULL(pb.DropnetCommission,0))) as 'Nett'
		,FORMAT(b.arrivalDate, 'dd-MMM-yyyy') AS [Arrival Date]
		,FORMAT(b.depDate, 'dd-MMM-yyyy') AS [Departure Date]
	, (b.airCode +' - '+b.airName) AS 'Name Of The Supplier'
	, (CASE WHEN b.AgentID!='B2C' THEN (SELECT DISTINCT mb.Code FROM mBranch mb WITH(NOLOCK) WHERE mb.Code = r.LocationCode) ELSE 'BOMRC' END) AS 'Branch'
	, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
	, b.frmSector AS 'Origin City'
	, b.toSector AS 'Destination City'
	--b.inserteddate as 'Booked Date'
	--, CASE WHEN  c.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),b.inserteddate,120))) -- 1 hour, 29 minutes and 13 seconds
 --  		WHEN c.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120))) -- 9 hour, 29 minutes and 16 seconds
 --  		WHEN c.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120))) -- 9 hour, 29 minutes and 16 seconds
 --  		WHEN c.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),b.inserteddate,120))   -- 0 hour, 0 minutes and 0 seconds   
 --		END AS 'Booked Date'
, FORMAT(
    CASE 
        WHEN c.CountryCode = 'AE' THEN DATEADD(SECOND, -1*60*60 - 29*60 - 13, b.inserteddate)
        WHEN c.CountryCode = 'US' THEN DATEADD(SECOND, -9*60*60 - 29*60 - 16, b.inserteddate)
        WHEN c.CountryCode = 'CA' THEN DATEADD(SECOND, -9*60*60 - 29*60 - 16, b.inserteddate)
        WHEN c.CountryCode = 'IN' THEN DATEADD(SECOND, 0, b.inserteddate)
    END
, 'dd-MMM-yyyy HH:mm:ss') AS [Booked Date]
	FROM tblBookMaster b WITH(NOLOCK)
	LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID
	INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId
	LEFT JOIN agentLogin al WITH(NOLOCK) ON cast(al.UserID AS VARCHAR(50))=b.AgentID
	INNER JOIN mCountry c WITH(NOLOCK) ON b.Country=c.CountryCode
	--INNER JOIN mBranch mb ON r.LocationCode=mb.Code
	WHERE ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))
 	AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))
	AND ((@AirlineCode = '') or (b.airCode = @AirlineCode))
	--AND ((@Country = '') OR ((B.AgentID!='B2C') and (al.BookingCountry = @Country)) OR ((B.AgentID='B2C' ) AND (B.Country=@Country)))
	AND ((@Country = '') 
		OR ((B.AgentID!='B2C') AND (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')))) 
		OR ((B.AgentID='B2C' ) AND (B.Country IN (SELECT Data FROM sample_split(@Country, ',')))))
	AND (((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) OR ((@BranchCode != '' AND @BranchCode = 'BOMRC')))
	AND ((@Status = '')
		OR ((@Status = 1) AND (b.BookingStatus=@Status) AND ( b.IsBooked=1))
		OR ((@Status != '') AND (b.BookingStatus=@Status)))
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAirlinesBookedReport] TO [rt_read]
    AS [dbo];

