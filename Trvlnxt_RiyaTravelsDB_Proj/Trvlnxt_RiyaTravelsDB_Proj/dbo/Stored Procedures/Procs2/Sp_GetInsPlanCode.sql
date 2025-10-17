CREATE Procedure [dbo].[Sp_GetInsPlanCode]
	@PlanID nvarchar(5) =null
AS
BEGIN
	SELECT Category,Value
	FROM [Insurance].[mCommonInsurance]
	WHERE ID=@PlanID and isactive=1
END
