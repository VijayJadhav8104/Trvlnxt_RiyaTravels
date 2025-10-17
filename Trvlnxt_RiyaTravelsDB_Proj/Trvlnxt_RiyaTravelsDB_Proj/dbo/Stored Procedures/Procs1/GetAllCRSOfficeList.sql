  
CREATE PROCEDURE [GetAllCRSOfficeList]  
@CompanyName VARCHAR(10) = null   
AS   
BEGIN  
 select b2.* from tbl_commonmaster b1

inner join tbl_commonmaster b2 on b1.pkid=b2.Mapping

where b1.Category='CRS' AND B1.CategoryValue=@CompanyName AND B2.UserTypeID=2

END  


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllCRSOfficeList] TO [rt_read]
    AS [dbo];

