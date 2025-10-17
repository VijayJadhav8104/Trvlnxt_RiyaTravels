CREATE PROCEDURE [dbo].[RTTBilling_InsertBookItinerary]
	@fkBookMaster BigInt
	,@orderId Varchar(30)
	,@riyaPNR Varchar(10)

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
	
	,@cabin Varchar(30)
	,@airlinePNR Varchar(50)
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
	,cabin
	,airlinePNR)
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
	,@cabin
	,@airlinePNR)

	SELECT SCOPE_IDENTITY();
END