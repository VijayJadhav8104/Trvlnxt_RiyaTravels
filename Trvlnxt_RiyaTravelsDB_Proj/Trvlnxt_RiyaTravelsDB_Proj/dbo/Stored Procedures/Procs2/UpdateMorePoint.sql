
--	UpdateMorePoint '1','1','1','22','1019','8','1','1'

CREATE PROCEDURE [dbo].[UpdateMorePoint]
	-- Add the parameters for the stored procedure here
    @Head nvarchar(max),
	@SubHead nvarchar(max),
	@Description nvarchar(max),
--	@CoverImage nvarchar(max),
	@PointImage nvarchar(max),
	@id nvarchar(max)=isnull,
	@BlogId nvarchar(max),
	@PointImgLink nvarchar(max),
	@PointImgUrl nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	update BlogTemplateDetails set
							PointHead=@Head,
							PointSubHead=@SubHead,
							PointDescription=@Description,
							Point_img_link=@PointImgLink,
							PointImgUrl=case when @PointImgUrl ='' then PointImgUrl else @PointImgUrl end,
							Point_Images=case when @PointImage ='' then Point_Images else @PointImage end
						where Id=@id
			select 0;

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateMorePoint] TO [rt_read]
    AS [dbo];

