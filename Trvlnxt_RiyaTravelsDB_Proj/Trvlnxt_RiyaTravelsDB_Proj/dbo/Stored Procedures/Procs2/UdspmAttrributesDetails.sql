--==================================            
--Created by : Sanjay Misal            
--Creation date : 04/08/2020             
-- Insert Data in mAttrributesDetails            
--==================================            
CREATE PROCEDURE [dbo].[UdspmAttrributesDetails]            
	@OrderID varchar(50),            
	@GDSPNR varchar(50)=NULL,            
	@JobCodeBookingGivenBy varchar(50)= null,            
	@VesselName varchar(50)= null,            
	@ReasonofTravel varchar(300)= null,            
	@TravelRequestNumber varchar(50) = null,            
	@CostCenter varchar(50)= null,            
	@BudgetCode varchar(15)= null,            
	@EmpDimession varchar(50)= null,            
	@SwonNo varchar(50)= null,            
	@TravelerType varchar(15)= null,            
	@Location varchar(15)= null,            
	@Department varchar(15)= null,            
	@Grade varchar(15)= null,            
	@Bookedby varchar(15)= null,            
	@Designation varchar(15)= null,            
	@Chargeability varchar(15)= null,            
	@NameofApprover varchar(15)= null,            
	@ReferenceNo varchar(15)= null,            
	@TR_POName varchar(15)= null,            
	@RankNo varchar(15)= null,            
	@AType varchar(15)= null,            
	@BookingReceivedDate varchar(30)= null,            
	@CreatedBy int= null,            
	@SeamanValue tinyint =0,            
	@paxvisa varchar(30)=null,            
	@txtOBTCno varchar(50)=null,
	@Changedcostno varchar(50)=null,            
	@Travelduration varchar(50)=null,            
	@TASreqno varchar(50)=null,            
	@Companycodecc varchar(50)=null,            
	@Projectcode varchar(50)=null,            
	@Traveltype varchar(50)=null,        
	@PanCardno varchar(50)=null,      
	@LOWEST_LOGICAL_FARE_1 varchar(50)=null,      
	@LOWEST_LOGICAL_FARE_2 varchar(50)=null,      
	@LOWEST_LOGICAL_FARE_3 varchar(50)=null,    
	@DeviationApproverNameandEMPCODE varchar(50)=null,  
	@CLIQCID varchar(100)=null,  
	@CLIQCONFIGID varchar(100)=null,
	@OUNameIDF Int = NULL,
	@RoleBand varchar(100)=null,
	@EmpLocation varchar(100)=null,
	@VerticalLocation varchar(100)=null,
	@Horizontal varchar(100)=null,
	@Vertical varchar(100)=null,
	@BTANO varchar(100)=null,
	--Added by JD
	@RequestID varchar(50) = null,
	@ConcurID varchar(50) = null,
	@ApproverName varchar(200) = null
AS            
BEGIN            

	IF EXISTS (SELECT orderid FROM mAttrributesDetails WHERE OrderID=@OrderID)            
	BEGIN            
		DELETE FROM mAttrributesDetails WHERE OrderID=@OrderID            
	END            
            
	INSERT INTO mAttrributesDetails(            
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
	CreatedBy,            
	SeamanValue,            
	paxvisa,            
	OBTCno,            
            
	Changedcostno,            
	Travelduration,            
	TASreqno,            
	Companycodecc,            
	Projectcode,            
	Traveltype,        
	PanCardno,      
	LOWEST_LOGICAL_FARE_1,      
	LOWEST_LOGICAL_FARE_2,      
	LOWEST_LOGICAL_FARE_3,    
	DEVIATION_APPROVER_NAME_AND_EMPCODE,  
	CLIQCID,  
	CLIQCONFIGID,
	OUNameIDF,
	RoleBand,
	EmpLocation,
	VerticalLocation,
	Horizontal,
	Vertical,
	BTANO,
	RequestID,
	ConcurID,
	ApproverName)

	VALUES(            
	@OrderID,            
	@GDSPNR,            
	@JobCodeBookingGivenBy,            
	@VesselName,            
	@ReasonofTravel,            
	@TravelRequestNumber,            
	@CostCenter,            
	@BudgetCode,            
	@EmpDimession,            
	@SwonNo,            
	@TravelerType,            
	@Location,            
	@Department,            
	@Grade,            
	@Bookedby,            
	@Designation,            
	@Chargeability,            
	@NameofApprover,            
	@ReferenceNo,            
	REPLACE(@TR_POName,'NA',''),            
	@RankNo,            
	@AType,            
	@BookingReceivedDate,            
	GETDATE(),            
	@CreatedBy,            
	@SeamanValue,            
	@paxvisa,            
	@txtOBTCno            
	,@Changedcostno            
	,@Travelduration            
	,REPLACE(@TASreqno,'-1','')            
	,@Companycodecc            
	,@Projectcode            
	,REPLACE(@Traveltype,'-1','')         
	,@PanCardno      
	,@LOWEST_LOGICAL_FARE_1      
	,@LOWEST_LOGICAL_FARE_2      
	,@LOWEST_LOGICAL_FARE_3    
	,@DeviationApproverNameandEMPCODE    
	,@CLIQCID  
	,@CLIQCONFIGID,
	@OUNameIDF,
	@RoleBand,
	@EmpLocation,
	@VerticalLocation,
	@Horizontal,
	@Vertical,
	@BTANO,
	@RequestID,
	@ConcurID,
	@ApproverName)

	SELECT SCOPE_IDENTITY();            

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspmAttrributesDetails] TO [rt_read]
    AS [dbo];

