-- ================================================      
-- Template generated from Template Explorer using:      
-- Create Procedure (New Menu).SQL      
-- =============================================      
-- Author:  Javed Bloch      
-- Description: to get vendor  details      
-- =============================================      
CREATE PROCEDURE [dbo].[Sp_GetVendorMappingDetails]      
@VendorName varchar(50)=null,      
@Country varchar(10)=null,    
 @UserType varchar(10),        
 @AgencyId varchar(10),  
 @OfficeId varchar(100)  
AS      
BEGIN    
 declare @VendorId varchar(max)        
       Declare @faretypeid varchar(max)=''  
	   set @VendorName = (case when @VendorName = 'Air India Express' then 'aiexpress' else @VendorName end);
 --check for single agency        
 if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and Replace(ASM.AgentId,',','')=@AgencyId )        
 begin     
    
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and Replace(ASM.AgentId,',','')=@AgencyId and ASM.Product='Air'        
  
 end        
    
 --added by bhavika check for agency id contains in multiple agency       
 else if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType       
    and @AgencyId in (SELECT Data FROM sample_split(ASM.AgentId, ','))  )       
 begin      
     
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country      
   and ASM.UserType=@UserType and  @AgencyId in (SELECT Data FROM sample_split(ASM.AgentId, ','))      
   
  --select * from mVendor where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and REPLACE(UPPER(VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')     
      
 end         
	
 --check for All agency        
 else if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and ASM.AgencyName='All' )        
 begin        
  
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and ASM.AgencyName='All'  and ASM.Product='Air'        
  --select * from mCommon where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and UPPER(Value)=UPPER(@VendorName)        
      print('p2')
 end        
  
 select @faretypeid=Value from mVendorCredential where OfficeId=@OfficeId and VendorId =(select ID from mVendor where REPLACE(UPPER(VendorName),' ','')=REPLACE(UPPER(@VendorName),' ','') and IsDeleted=0 and IsActive=1) and FieldName='Fare Type'   
print(@VendorId)  
    
 select 'VendorAgencyCount' FieldName,cast(Count(id) as varchar) FieldValue from mVendor where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and REPLACE(UPPER(VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')        
 union  
 select 'VendorInterCompanyCount' FieldName,cast(Count(vi.id) as varchar) FieldValue from mVendorInterCompany  vi      
 inner join mVendor v on v.ID=vi.VendorId      
 inner join mCountry c on c.ID=vi.CountryId      
 where REPLACE(UPPER(v.VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')  and c.CountryCode=@Country   and vi.IsActive=1   
 and vi.VendorCode !='' and vi.Custd !='' and vi.OfficeId=@OfficeId 
 union  
select 'FareType' FieldName,FareType FieldValue  from mFareTypeByAirline where ID in (SELECT Data FROM sample_split((@faretypeid), ','))  
 union  
 select 'ProductClass' FieldName,ProductClass FieldValue  from mFareTypeByAirline where ID in (SELECT Data FROM sample_split((@faretypeid), ','))  
    union
   select 'BaseCurrency' FieldName ,vc.Value FieldValue from mVendor v inner join
 mVendorCredential vc on v.ID=vc.VendorId
 where vc.FieldName='Currency'  AND v.IsDeleted=0 AND VC.IsActive=1  and vc.OfficeId=@OfficeId
 and  REPLACE(UPPER(v.VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '') 

 union  
	
 select 'CRSName' AS FieldName, CONVERT(VARCHAR(10), pkid) AS FieldValue  from tbl_commonmaster where CRSName=@VendorName

END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorMappingDetails] TO [rt_read]
    AS [dbo];

