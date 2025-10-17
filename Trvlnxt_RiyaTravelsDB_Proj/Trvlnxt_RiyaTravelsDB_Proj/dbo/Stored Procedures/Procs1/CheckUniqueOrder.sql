-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckUniqueOrder]
	-- Add the parameters for the stored procedure here
	@No int = null,
	@Action varchar(50)=null,
	@PKID varchar(50)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@Action='City')
		begin
		 IF LEN(ISNULL(@PKID, '')) = 0
		   BEGIN
			   if  exists(select DisplayOrder from TblCity where DisplayOrder=@No and IsActive=0)
			       select 0 as OrderNo;
			   else
			       select 1 as OrderNo
			END
			ELSE
			BEGIN
			   if  exists(select DisplayOrder from TblCity where DisplayOrder=@No and IsActive=0 AND Id=@PKID)
			      select 1 as OrderNo
		    	else if exists(select DisplayOrder from TblCity where DisplayOrder=@No and IsActive=0)
			       select 0 as OrderNo;
				else 
				   select 1 as OrderNo;
			END
		end

	if(@Action='Country')
		begin
		 IF LEN(ISNULL(@PKID, '')) = 0
		   BEGIN
		   --if null
		     if  exists(select DisplayOrder from Conti_Country where DisplayOrder=@No and IsActive=0)
			      select 0 OrderNo;
		   	   else
			      select 1 as OrderNo;
	       END
		   ELSE
		   BEGIN
		     
		      if  exists(select DisplayOrder from Conti_Country where DisplayOrder=@No and IsActive=0 AND Id=@PKID)
			      select 1 OrderNo;
			  else if exists(select DisplayOrder from Conti_Country where DisplayOrder=@No and IsActive=0)
			      select 0 as OrderNo;
				  else 
				  select 1 as OrderNo;
		   END
		end
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckUniqueOrder] TO [rt_read]
    AS [dbo];

