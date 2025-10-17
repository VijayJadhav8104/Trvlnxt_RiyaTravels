-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[SpGetCountry_by_PageIndex_and_PageSize] 
	-- Add the parameters for the stored procedure here
	
	@PageIndex int,
	@PageSize int,
	@TotalRows int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- select eid,ename,address,dept,salary from 
    --(select ROW_NUMBER() over(order by eid) as rowNumber,eid,ename,address,dept,salary 
   -- from Employees
   -- )emp where rowNumber>=@StartRowIndex and rowNumber<=@EndRowIndex
   -- select @TotalRows=COUNT(*) from Employees



    declare @StartRowIndex int
    declare @EndRowIndex int
    set @StartRowIndex=(@PageIndex*@PageSize)+1;
    set @EndRowIndex=(@PageIndex+1)*@PageSize;
	select Id,CountryName from(select ROW_NUMBER()over(order by Id)as rowNumber,Id,CountryName from Conti_Country
	where IsActive=0)country
	where rowNumber>=@StartRowIndex and rowNumber<=@EndRowIndex 

	select @TotalRows=COUNT(*) from Conti_Country

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpGetCountry_by_PageIndex_and_PageSize] TO [rt_read]
    AS [dbo];

