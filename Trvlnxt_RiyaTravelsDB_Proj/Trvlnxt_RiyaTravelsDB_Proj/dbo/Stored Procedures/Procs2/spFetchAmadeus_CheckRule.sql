  
CREATE Proc [dbo].[spFetchAmadeus_CheckRule]
@CategoryList varchar(max) = '',
@VendorName varchar(10) = ''

AS  
BEGIN

	if (@CategoryList = 'ALL')
		begin
			SELECT * FROM Amadeus_CheckRule where VendorName = @VendorName order by DisplayOrder 
		end
	else
		SELECT * FROM Amadeus_CheckRule where VendorName = @VendorName and Category IN (select Data from sample_split(@CategoryList,',')) order by DisplayOrder

END  
 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spFetchAmadeus_CheckRule] TO [rt_read]
    AS [dbo];

