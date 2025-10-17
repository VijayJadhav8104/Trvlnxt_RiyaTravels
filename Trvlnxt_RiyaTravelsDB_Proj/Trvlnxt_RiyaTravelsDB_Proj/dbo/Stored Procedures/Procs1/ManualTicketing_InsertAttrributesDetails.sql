CREATE PROCEDURE [dbo].[ManualTicketing_InsertAttrributesDetails] 
	 @OrderID Varchar(50) = NULL
	,@GDSPNR Varchar(50) = NULL
	,@JobCodeBookingGivenBy Varchar(50) = NULL
	,@VesselName Varchar(50) = NULL
	,@ReasonofTravel Varchar(300) = NULL
	,@TravelRequestNumber Varchar(15)  = NULL
	,@CostCenter Varchar(50)  = NULL
	,@BudgetCode Varchar(15) = NULL
	,@EmpDimession Varchar(50) = NULL
	,@SwonNo Varchar(15) = NULL
	,@TravelerType Varchar(15) = NULL
	,@Location Varchar(15) = NULL
	,@Department Varchar(15) = NULL
	,@Grade Varchar(15) = NULL
	,@Bookedby Varchar(15) = NULL
	,@Designation Varchar(15) = NULL
	,@Chargeability Varchar(15) = NULL
	,@NameofApprover Varchar(15) = NULL
	,@ReferenceNo Varchar(15) = NULL
	,@TR_POName Varchar(15) = NULL
	,@RankNo Varchar(15) = NULL
	,@AType  Varchar(15) = NULL
	,@BookingReceivedDate Varchar(30) = NULL
	,@SeamanValue Bit = NULL
	,@paxvisa	Varchar(30) = NULL
	,@OBTCno	Varchar(50) = NULL
	,@PanCardno	Varchar(50) = NULL
	,@Traveltype Varchar(50) = NULL
	,@Changedcostno Varchar(50) = NULL
	,@Travelduration Varchar(50) = NULL
	,@TASreqno Varchar(50) = NULL
	,@Companycodecc Varchar(50) = NULL
	,@Projectcode Varchar(50) = NULL
	,@DeviationApproverNameandEMPCODE Varchar(255) = NULL
	,@LOWEST_LOGICAL_FARE_1 Varchar(50) = NULL
	,@LOWEST_LOGICAL_FARE_2 Varchar(50) = NULL
	,@LOWEST_LOGICAL_FARE_3 Varchar(50) = NULL
	,@CLIQCID Varchar(100) = NULL
	,@CLIQCONFIGID Varchar(100) = NULL-- NULL
	,@OUNameIDF Int= NULL
	,@RoleBand Varchar(100)  = NULL
	,@EmpLocation Varchar(100)  = NULL
	,@VerticalLocation Varchar(100)  = NULL
	,@Horizontal Varchar(100) = NULL
	,@Vertical Varchar(100) = NULL
	,@BTANO	 Varchar(50) = NULL
	,@RequestID	 Varchar(50) = NULL
	,@CreatedBy Int = NULL
	,@fkPassengerid BigInt = NULL
	,@PaxName Varchar(255) = NULL
	,@SectorNo  Int = NULL
	,@FareType Varchar(25) = NULL
	,@FareRule Varchar(25) = NULL
	,@Remarks Varchar(200) = NULL
	,@CarbonFootprint Varchar(200) = NULL
	,@CurrencyConversionRate Varchar(50) = NULL
	,@PID Varchar(200) = NULL
	,@Account Varchar(200) = NULL
	,@UID Varchar(200) = NULL
	,@ProjectName Varchar(200) = NULL
	,@CostCentre Varchar(200) = NULL
	,@ConcurID Varchar(200) = NULL
	,@ApproverName Varchar(200) = NULL
	,@GESSRECEIVEDDATE Varchar(200) = NULL
	,@TicketType Varchar(200) = NULL
	,@EmpIDTRAVELOFFICER Varchar(200) = NULL
	,@DEVIATIONAPPROVER Varchar(200) = NULL
	,@EMPLOYEESPOSITION Varchar(200) = NULL
	,@TRAVELCOSTREIMBURSABLE Varchar(200) = NULL
	,@EMPLOYEEORGUNIT Varchar(200) = NULL
	,@EMPLOYEELOCATIONDESCRIPTION Varchar(200) = NULL
	,@EMPLOYEELOCATIONCODE Varchar(200) = NULL
	,@EMPLOYEEPROJECTCODE Varchar(200) = NULL
	,@EMPLOYEEMARKET Varchar(200) = NULL
	,@EMPLOYEESUBMARKET Varchar(200) = NULL
	,@REASONFORDEVIATIONAIR Varchar(200) = NULL
	,@BillingEntityName Varchar(200) = NULL
	,@Issuancedate Varchar(200) = NULL
	,@TripPurpose Varchar(200) = NULL
	,@ProjectNo Varchar(200) = NULL
	,@TravelReason Varchar(200) = NULL
	,@Project_Code Varchar(50) = NULL
	,@TravelExpenseType Varchar(50) = NULL
	,@CartNumber Varchar(50) = NULL
	,@CartStatus Varchar(50) = NULL
	,@BookedByName Varchar(50) = NULL
	,@TypeofTransaction Varchar(50) = NULL
	,@SBU Varchar(250) = NULL
	,@PurposeofTravel Varchar(250) = NULL
	,@InternalOrder Varchar(250) = NULL
	,@ServiceRequestID Varchar(250) = NULL
	,@TripID Varchar(250) = NULL

AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO mAttrributesDetails (orderId
	,GDSPNR
	,JobCodeBookingGivenBy
	,VesselName
	,ReasonofTravel
	,TravelRequestNumber
	,CostCenter 
	,BudgetCode
	,EmpDimession
	,SwonNo 
	,TravelerType
	,Location
	,Department
	,Grade
	,Bookedby
	,Designation
	,Chargeability
	,NameofApprover
	,ReferenceNo
	,TR_POName
	,RankNo
	,AType
	,BookingReceivedDate
	,CreatedOn
	,CreatedBy
	,SeamanValue
	,paxvisa 
	,OBTCno
	,PanCardno
	,Traveltype
	,Changedcostno
	,Travelduration
	,TASreqno
	,Companycodecc
	,Projectcode
	,DEVIATION_APPROVER_NAME_AND_EMPCODE 
	,LOWEST_LOGICAL_FARE_1
	,LOWEST_LOGICAL_FARE_2
	,LOWEST_LOGICAL_FARE_3
	,CLIQCID 
	,CLIQCONFIGID
	,OUNameIDF
	,RoleBand 
	,EmpLocation 
	,VerticalLocation
	,Horizontal 
	,Vertical
	,BTANO 
	,RequestID
	,fkPassengerid
	,PaxName
	,SectorNo
	,FareType
	,FareRule
	,Remarks
	,CarbonFootprint
	,CurrencyConversionRate
	,PID
	,Account
	,UID
	,ProjectName
	,CostCentre
	,ConcurID
	,ApproverName
	,GESSRECEIVEDDATE
	,TicketType
	,EmpIDTRAVELOFFICER
	,DEVIATIONAPPROVER
	,EMPLOYEESPOSITION
	,TRAVELCOSTREIMBURSABLE
	,EMPLOYEEORGUNIT
	,EMPLOYEELOCATIONDESCRIPTION
	,EMPLOYEELOCATIONCODE
	,EMPLOYEEPROJECTCODE
	,EMPLOYEEMARKET
	,EMPLOYEESUBMARKET
	,REASONFORDEVIATIONAIR
	,BillingEntityName
	,Issuancedate	
	,TripPurpose
	,ProjectNo
	,TravelReason
	,Project_Code
	,TravelExpenseType
	,CartNumber
	,CartStatus
	,BookedByName
	,TypeofTransaction
	,SBU
	,PurposeofTravel
	,InternalOrder
	,ServiceRequestID
	,TripID) 
	VALUES (@OrderID
	,@GDSPNR
	,@JobCodeBookingGivenBy
	,@VesselName
	,@ReasonofTravel
	,@TravelRequestNumber
	,@CostCenter 
	,@BudgetCode
	,@EmpDimession
	,@SwonNo 
	,@TravelerType
	,@Location
	,@Department
	,@Grade
	,@Bookedby
	,@Designation
	,@Chargeability
	,@NameofApprover
	,@ReferenceNo
	,@TR_POName
	,@RankNo
	,@AType
	,@BookingReceivedDate
	,GETDATE()
	,@CreatedBy
	,@SeamanValue
	,@paxvisa 
	,@OBTCno
	,@PanCardno
	,@Traveltype
	,@Changedcostno
	,@Travelduration
	,@TASreqno
	,@Companycodecc
	,@Projectcode
	,@DeviationApproverNameandEMPCODE 
	,@LOWEST_LOGICAL_FARE_1
	,@LOWEST_LOGICAL_FARE_2
	,@LOWEST_LOGICAL_FARE_3
	,@CLIQCID 
	,@CLIQCONFIGID
	,@OUNameIDF
	,@RoleBand 
	,@EmpLocation 
	,@VerticalLocation
	,@Horizontal 
	,@Vertical
	,@BTANO 
	,@RequestID
	,@fkPassengerid
	,@PaxName
	,@SectorNo
	,@FareType
	,@FareRule
	,@Remarks
	,@CarbonFootprint
	,@CurrencyConversionRate
	,@PID
	,@Account
	,@UID
	,@ProjectName
	,@CostCentre
	,@ConcurID
	,@ApproverName
	,@GESSRECEIVEDDATE
	,@TicketType
	,@EmpIDTRAVELOFFICER
	,@DEVIATIONAPPROVER
	,@EMPLOYEESPOSITION
	,@TRAVELCOSTREIMBURSABLE
	,@EMPLOYEEORGUNIT
	,@EMPLOYEELOCATIONDESCRIPTION
	,@EMPLOYEELOCATIONCODE
	,@EMPLOYEEPROJECTCODE
	,@EMPLOYEEMARKET
	,@EMPLOYEESUBMARKET
	,@REASONFORDEVIATIONAIR
	,@BillingEntityName
	,@Issuancedate
	,@TripPurpose
	,@ProjectNo
	,@TravelReason
	,@Project_Code
	,@TravelExpenseType
	,@CartNumber
	,@CartStatus
	,@BookedByName
	,@TypeofTransaction
	,@SBU
	,@PurposeofTravel
	,@InternalOrder
	,@ServiceRequestID
	,@TripID)
   
	SELECT SCOPE_IDENTITY();
END