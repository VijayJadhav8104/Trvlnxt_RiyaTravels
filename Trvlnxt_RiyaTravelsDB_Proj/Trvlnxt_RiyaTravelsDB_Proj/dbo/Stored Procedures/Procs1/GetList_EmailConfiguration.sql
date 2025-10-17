
CREATE procedure [dbo].[GetList_EmailConfiguration]

@Type varchar(50),
@Country varchar(50)


--declare
--@Type varchar(50)='CardAuthorize',
--@Country varchar(50)='US'

as
begin


DECLARE   @ConcatString VARCHAR(4000)
SELECT   @ConcatString = COALESCE(@ConcatString + ', ', '') + ToEmailID FROM EmailConfiguration 
where InquiryType = @Type and Country= @Country
SELECT   @ConcatString AS EmailID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_EmailConfiguration] TO [rt_read]
    AS [dbo];

