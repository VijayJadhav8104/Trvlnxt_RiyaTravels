CREATE PROCEDURE [dbo].[GetGkSegmentOfficeID]
(  
  @CountryCode VARCHAR(10),
  @GroupId VARCHAR(10)
)  
AS  
BEGIN 
IF(@GroupId=3 and @CountryCode='CA')
BEGIN
select top 1 OfficeID from GkSegmentOfficeID where  CountryCode =@CountryCode and GroupId=@GroupId
END
ELSE IF(@GroupId=3)
BEGIN
select top 1 OfficeID from GkSegmentOfficeID where  CountryCode ='' and GroupId=@GroupId
END
ELSE
BEGIN
select top 1 OfficeID from GkSegmentOfficeID where  CountryCode = @CountryCode and GroupId=''
END


END


