
CREATE PROC [dbo].[CMS_GetAllBranches]
  AS
  BEGIN
		BEGIN
			SELECT Id,Branch FROM tblBranch
		END
  END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetAllBranches] TO [rt_read]
    AS [dbo];

