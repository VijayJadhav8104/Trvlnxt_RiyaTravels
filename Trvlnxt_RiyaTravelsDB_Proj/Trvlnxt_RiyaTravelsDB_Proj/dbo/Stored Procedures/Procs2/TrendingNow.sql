CREATE PROCEDURE [dbo].[TrendingNow]
 
-- Add the parameters for the stored procedure here
@Id int=null,
@Country nvarchar(max)=null,
@BannerType nvarchar(max)=null,
@Heading nvarchar(max)=null,
@ImagePath nvarchar(max)=null,
@Description nvarchar(max)=null,
@ImageButtonText nvarchar(max)=null,
@ImageButtonURL nvarchar(max)=null,
@SpecialBannerDesc nvarchar(max)=null,
@StartDate datetime = null,
@EndDate datetime =null,
@BannerOrder int=null,
@ActionName nvarchar(max)=null

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @ResultValue int ;
    -- Insert statements for procedure here
IF (@ActionName = 'Insert') 
BEGIN  
if not exists(select BannerOrder,Country from tblTrendingNow where BannerOrder=@BannerOrder and Country=@Country AND IsActive=1)
begin
insert into tblTrendingNow(Country,
BannerType,
Heading,
ImagePath,
Description,
ImageButtonText,
ImageButtonURL,
SpecialBannerDesc,
StartDate,
EndDate,
BannerOrder) 
values(@Country,
@BannerType,
@Heading,
@ImagePath,
@Description,
@ImageButtonText,
@ImageButtonURL,
@SpecialBannerDesc,
@StartDate,
@EndDate,
@BannerOrder)  


end

END  

---- Data Get All
else IF (@ActionName = 'Select') 
BEGIN  
select 
BannerType = case when BannerType = 1 then 'Normal' else 'Special' end,
Country = case  when Country = 'IN' then 'India' 
when Country = 'US' then 'USA' 
when Country = 'CA' then 'Canada' 
when Country = 'AE' then 'Dubai'   end,
   -- Heading = case  when Heading = '' then 'No Heading' else Heading,
* from tblTrendingNow
where IsActive=1 order by BannerOrder asc
END  

---- Data Get By Id
else IF @ActionName = 'Edit'  
BEGIN  
select * from tblTrendingNow 
where PKID=@Id and IsActive=1
END  

---- data Update
IF @ActionName = 'Update'  
BEGIN  
UPDATE tblTrendingNow SET  
Country=@Country,
BannerType=@BannerType,
Heading=@Heading,
ImagePath = case when @ImagePath ='' then ImagePath else @ImagePath end,
[Description]=@Description,
ImageButtonText=@ImageButtonText,
ImageButtonURL=@ImageButtonURL,
SpecialBannerDesc=@SpecialBannerDesc,
StartDate=@StartDate,
EndDate=@EndDate,
BannerOrder=@BannerOrder
WHERE PKID = @Id  

END  


else IF @ActionName = 'Delete'  
BEGIN  
update tblTrendingNow set IsActive=0 WHERE PKID = @id  
set @ResultValue=1;

END  


else IF @ActionName = 'UniqueOrder'  
BEGIN  
select Country,BannerOrder from tblTrendingNow 
WHERE IsActive=1 and Country=@Country and BannerOrder=@BannerOrder and PKID!=@Id

END  


END


------flag values
------Record exists = 11
------ok = 1






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[TrendingNow] TO [rt_read]
    AS [dbo];

