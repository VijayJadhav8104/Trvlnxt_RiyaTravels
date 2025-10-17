-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Rail].[GetAppliedServiceFee]
@AppliedServiceFeeId varchar(10) = null  
AS
BEGIN
	Select * from Rail.Agent_ServiceFee_Mapper where Id = @AppliedServiceFeeId
END
