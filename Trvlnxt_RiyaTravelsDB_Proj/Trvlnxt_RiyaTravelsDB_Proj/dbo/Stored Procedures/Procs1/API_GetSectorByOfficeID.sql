        
create PROCEDURE [dbo].[API_GetSectorByOfficeID]          
@OfficeId varchar(10)     
AS          
BEGIN  
  
select * from sectors where [Country Code] in (select top 1 Value from mVendorCredential where    
OfficeId=@OfficeId and FieldName='ERP Country'  order by CreatedOn desc)    
    
END   
  
  
  
  