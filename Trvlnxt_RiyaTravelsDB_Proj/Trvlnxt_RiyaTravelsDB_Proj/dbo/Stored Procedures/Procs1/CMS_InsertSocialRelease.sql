
CREATE PROCEDURE [dbo].[CMS_InsertSocialRelease] 
	-- Add the parameters for the stored procedure here
	@type char(1),
	@desc varchar(500),
	@image varchar(max),
	@order int,
	@title varchar(100),
	@date varchar(50),
	@bdesc text,
	@id bigint,
	@thumb varchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@id=0)
    begin
    insert into CMS_SocialRelease(title_vc,img_vc,order_in,des_vc,type_ch,date_dt,briefdes_vc,thumbimg_vc) values(@title,@image,@order,@desc,@type,@date,@bdesc,@thumb)
    select 1
    end
    else
    begin
    update CMS_SocialRelease set title_vc=@title,img_vc=@image,order_in=@order,des_vc=@desc,type_ch=@type,date_dt=@date,briefdes_vc=@bdesc,thumbimg_vc=@thumb where PKID_in=@id
   select 2
    end
    
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertSocialRelease] TO [rt_read]
    AS [dbo];

