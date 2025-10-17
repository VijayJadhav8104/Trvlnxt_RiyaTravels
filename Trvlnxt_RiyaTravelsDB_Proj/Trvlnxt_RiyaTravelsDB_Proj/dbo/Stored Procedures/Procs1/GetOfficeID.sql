CREATE PROCEDURE GetOfficeID
(  
      @Business VARCHAR(10)
	  ,@CountryCode VARCHAR(10)  
)  
AS  
--DECLARE @ResultValue VARCHAR(100) = null   
BEGIN 
--set @ResultValue = (
select OfficeID from tblAmadeusOfficeID where CompanyName= '1A' and Business =  @Business and CountryCode =@CountryCode
--)

END
--RETURN @ResultValue 



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetOfficeID] TO [rt_read]
    AS [dbo];

