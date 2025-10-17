CREATE PROCEDURE [dbo].[UdspGetAttrributesDetails]          
	@GDSPNR varchar(50)          
AS          
BEGIN          

	SELECT TOP 1          
	OrderID,          
	GDSPNR,          
	JobCodeBookingGivenBy,          
	VesselName,          
	ReasonofTravel,          
	TravelRequestNumber,          
	CostCenter,          
	BudgetCode,          
	EmpDimession,          
	SwonNo,          
	TravelerType,          
	Location,          
	Department,          
	Grade,          
	Bookedby,          
	Designation,          
	Chargeability,          
	NameofApprover,          
	ReferenceNo,          
	TR_POName,          
	RankNo,          
	AType,          
	BookingReceivedDate,          
	CreatedOn,  
	Changedcostno,  
	Travelduration,  
	TASreqno,  
	Companycodecc,  
	Projectcode,  
	Traveltype,  
	CreatedBy,
	OBTCno,
	PanCardno,
	LOWEST_LOGICAL_FARE_1,
	LOWEST_LOGICAL_FARE_2,
	LOWEST_LOGICAL_FARE_3,
	DEVIATION_APPROVER_NAME_AND_EMPCODE,
	ISNULL(OUNameIDF,0) AS OUNameIDF,
	RoleBand,
	EmpLocation,
	Vertical,
	VerticalLocation,
	Horizontal,
	BTANO,
	RequestID,
	fkPassengerid,
	PaxName,
	SectorNo,
	FareType,
	FareRule,
	ConcurID,
	ApproverName
	FROM mAttrributesDetails 
	WHERE GDSPNR = @GDSPNR 
	ORDER BY ID DESC          

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetAttrributesDetails] TO [rt_read]
    AS [dbo];

