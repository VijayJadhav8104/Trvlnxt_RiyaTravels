-- =============================================
-- Author:		Hardik
-- Create date: 25.09.2023
-- Description:	Assign Inquiry Staff ID
-- =============================================
CREATE PROCEDURE HolidayInquiry_AssignInquiryTMSEmpCode
	@HolidayInquiryIDP BigInt
	,@EmpCode Varchar(50)
	,@TMSUserID_Assign Int
	,@OUTVAL Int OUTPUT
	,@OUTMSG Varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MainAgentID Int

	SELECT TOP 1 @MainAgentID = ID FROM mUser WHERE EmployeeNo = @EmpCode

    UPDATE HolidayInquiry SET AssignTMSUserID = @MainAgentID
	, TMSEmployeeCode_Assign = @EmpCode 
	, TMSUserID_Assign = @TMSUserID_Assign
	WHERE HolidayInquiryIDP = @HolidayInquiryIDP

	SET @OUTVAL = 1
	SET @OUTMSG = 'Inquiry assigned successfully.'
END