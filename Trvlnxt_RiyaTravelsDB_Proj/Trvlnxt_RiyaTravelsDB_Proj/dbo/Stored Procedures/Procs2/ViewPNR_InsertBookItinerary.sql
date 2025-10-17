CREATE PROCEDURE [dbo].[ViewPNR_InsertBookItinerary]
	@fkBookMaster BigInt
	,@orderId Varchar(30)
	,@frmSector Varchar(50)
	,@toSector Varchar(50)
	,@fromAirport Varchar(150)= null
	,@toAirport Varchar(150)=null
	,@airName Varchar(150)=null
	,@operatingCarrier Varchar(50)=null
	,@airCode Varchar(10)=null
	,@flightNo Varchar(10)
	,@isReturnJourney Bit
	,@depDate Date
	,@arrivalDate Date
	,@riyaPNR Varchar(10)
	,@deptTime DateTime
	,@arrivalTime DateTime
	,@cabin Varchar(30)= null
	,@farebasis Varchar(30) = NULL
	,@airlinePNR Varchar(50)=null
	,@fromTerminal Varchar(20) = NULL
	,@toTerminal Varchar(20) = NULL
	,@ParentOrderId Varchar(50) = NULL
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
	,ParentOrderId)
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
	,@ParentOrderId)

	SELECT SCOPE_IDENTITY();
END