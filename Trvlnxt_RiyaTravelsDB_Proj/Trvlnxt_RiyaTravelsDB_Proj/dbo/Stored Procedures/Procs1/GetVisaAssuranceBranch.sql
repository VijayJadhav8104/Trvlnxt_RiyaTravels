-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetVisaAssuranceBranch]
	-- Add the parameters for the stored procedure here
	@StateId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	if(@StateId != 0)
	Begin
	 		select
				bd.Id,
				bd.BranchLocation as Branch 
			from
				tblBranchDimension bd 
				inner join
					tblStateCode sc 
					on bd.StateId = sc.Id 
				where sc.Id=@StateId
	End

	else
		Begin
			  select
			    bd.Id,
			    bd.BranchLocation as Branch 
			 from
			    tblBranchDimension bd 
			    inner join
			       tblStateCode sc 
			       on bd.StateId = sc.Id 
		End
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetVisaAssuranceBranch] TO [rt_read]
    AS [dbo];

