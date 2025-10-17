CREATE PROCEDURE [dbo].[ManualTicketing_InsertBookItinerary]
	@fkBookMaster BigInt
	,@orderId Varchar(30)
	,@frmSector Varchar(50)
	,@toSector Varchar(50)
	,@fromAirport Varchar(150)
	,@toAirport Varchar(150)
	,@airName Varchar(150)
	,@operatingCarrier Varchar(50)
	,@airCode Varchar(10)
	,@flightNo Varchar(10)
	,@isReturnJourney Bit
	,@depDate Date
	,@arrivalDate Date
	,@riyaPNR Varchar(10)
	,@deptTime DateTime
	,@arrivalTime DateTime
	,@cabin Varchar(30)
	,@farebasis Varchar(30) = NULL
	,@airlinePNR Varchar(50)
	,@fromTerminal Varchar(20) = NULL
	,@toTerminal Varchar(20) = NULL
	,@TotalTime Varchar(20) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO tblBookItenary (fkBookMaster
	,orderId
	,frmSector
	,toSector
	,fromAirport
	,toAirport
	,airName
	,operatingCarrier
	,airCode
	,flightNo
	,isReturnJourney
	,depDate
	,arrivalDate
	,deptTime
	,arrivalTime
	,cabin
	,farebasis
	,airlinePNR
	,fromTerminal
	,toTerminal
	,TotalTime)
	VALUES (@fkBookMaster
	,@orderId
	,@frmSector
	,@toSector
	,@fromAirport
	,@toAirport
	,@airName
	,@operatingCarrier
	,@airCode
	,@flightNo
	,@isReturnJourney
	,@depDate
	,@arrivalDate
	,@deptTime
	,@arrivalTime
	,@cabin
	,@farebasis
	,@airlinePNR
	,@fromTerminal
	,@toTerminal
	,@TotalTime)

	SELECT SCOPE_IDENTITY();
END