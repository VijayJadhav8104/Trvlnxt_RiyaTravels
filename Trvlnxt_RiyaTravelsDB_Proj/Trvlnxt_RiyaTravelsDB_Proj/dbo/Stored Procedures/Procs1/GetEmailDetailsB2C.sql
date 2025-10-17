-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEmailDetailsB2C]
	-- Add the parameters for the stored procedure here
@Type varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
		  stuff(
			(
			  SELECT 
				',' + s.[TO] 
			  FROM 
				tbl_InqueryEmail s 
				where s.[Type]=@Type
			    and s.IsActive=1
				FOR XML PATH('')
			), 
			1, 
			1, 
			''
		  ) [TO], 
		  stuff(
			(
			  SELECT 
				',' +s.[CC]
			  FROM 
				tbl_InqueryEmail s
				where s.Type=@Type
			    and s.IsActive=1
				 FOR XML PATH('')
			), 
			1, 
			1, 
			''
		  ) CC, 
		  stuff(
			(
			  SELECT 
				',' + s.[BCC] 
			  FROM 
				tbl_InqueryEmail s 
				where s.Type=@Type
			    and s.IsActive=1
				FOR XML PATH('')
			), 
			1, 
			1, 
			''
		  ) BCC

END
