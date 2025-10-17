CREATE PROCEDURE [dbo].[InsertAdvertisementImages]
-- Add the parameters for the stored procedure here

@advertisement nvarchar(max),
@BlogId nvarchar(max),
@Advertisementurl nvarchar(max)=null 

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    -- Insert statements for procedure here
if exists (select AdvertisementImage from AdvertisementMaster where BlogId=@BlogID)
begin
--insert into AdvertisementMaster(AdvertisementImage,InsertDate,BlogId)values(@advertisement,GETDATE(),@BlogId)

update AdvertisementMaster set AdvertisementURL=@Advertisementurl,
  AdvertisementImage=case when @advertisement ='' then AdvertisementImage else @advertisement end
  ----	AdvertisementImage=@advertisement
where BlogId=@BlogId


if not exists(select AdvertisementImage,BlogId from AdvertisementMaster where BlogId=@BlogID)
insert into AdvertisementMaster(AdvertisementImage,InsertDate,BlogId ,AdvertisementURL)
values(@advertisement,GETDATE(),@BlogId ,@Advertisementurl)

end

else if not exists(select AdvertisementImage from AdvertisementMaster where Id=@BlogID)
begin
insert into AdvertisementMaster(AdvertisementImage,InsertDate,BlogId ,AdvertisementURL)
values(@advertisement,GETDATE(),@BlogId ,@Advertisementurl)
end

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertAdvertisementImages] TO [rt_read]
    AS [dbo];

