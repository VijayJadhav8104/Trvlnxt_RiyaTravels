--exec GetOfficeListAgencyWise 'null','amadeus','51366'             
CREATE PROCEDURE [dbo].[GetOfficeListAgencyWise]      
@CompanyName VARCHAR(10) = null   ,      
@VendorName VARCHAR(50) = null   ,      
@AgencyID varchar(10)      
AS         
BEGIN        
   
 if exists(select * from magencyOfficeIdMapping where agentid=@AgencyID and isActive=1)      
 begin      
  if exists(SELECT o.ID FROM magencyOfficeIdMapping  O        
  inner join mVendorCredential C on o.OfficeId=c.OfficeId       
  inner join mVendor V on V.ID=O.FKmVendor      
  WHERE replace(UPPER(C.FieldName),' ','')='DisplayName' and c.IsActive=1  and agentid=@AgencyID and replace(UPPER(V.VendorName),' ','')=UPPER(@VendorName) )                
  begin             
   SELECT o.ID,replace(replace(O.OfficeId,CHAR(10),''),CHAR(13),'') OfficeId,C.Value As 'OfficeIdName' FROM magencyOfficeIdMapping  O       
   inner join mVendorCredential C on replace(replace(o.OfficeId,CHAR(10),''),CHAR(13),'')=replace(replace(c.OfficeId,CHAR(10),''),CHAR(13),'')       
   inner join mVendor V on V.ID=O.FKmVendor and v.ID=c.VendorId and V.IsDeleted=0 and V.IsActive=1      
   WHERE replace(UPPER(C.FieldName),' ','')='DisplayName' and c.IsActive=1  and O.IsActive=1       
   and agentid=@AgencyID and replace(UPPER(V.VendorName),' ','')=UPPER(@VendorName)  
   order by OfficeId asc
  end                  
end      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetOfficeListAgencyWise] TO [rt_read]
    AS [dbo];

