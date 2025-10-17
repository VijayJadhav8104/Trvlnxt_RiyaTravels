      
-- =============================================      
-- Author:  bhavika kawa      
-- Description: to get vendor based on agency      
-- =============================================      
CREATE PROCEDURE [dbo].[Sp_GetVendorByAgencyId]      
 @Country varchar(10),      
 @UserType varchar(10),      
 @AgencyId varchar(10),      
 @VendorName varchar(20)      
AS      
BEGIN      
declare @VendorId varchar(max)      
      
 --check for single agency      
 if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and replace(ASM.AgentId,',','')=@AgencyId )      
 begin      
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and replace(ASM.AgentId,',','')=@AgencyId and ASM.Product='Air'      
  select * from mVendor where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and REPLACE(UPPER(VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')      
 print('p1')
 --select * from mCommon where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and UPPER(Value)=UPPER(@VendorName)      
 end      
      
 --check for agency id contains in multiple agency       
 else if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType       
    and @AgencyId in (SELECT Data FROM sample_split(ASM.AgentId, ','))  )       
 begin      
 print('p2')
     
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country      
   and ASM.UserType=@UserType and  @AgencyId in (SELECT Data FROM sample_split(ASM.AgentId, ','))      
       print(@VendorId)
  select * from mVendor where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and REPLACE(UPPER(VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')     
      
 end      
      
 --check for All agency      
 else if exists(Select ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and ASM.AgencyName='All' )      
 begin      
  Select @VendorId=ASM.VendorId from tbl_AgentSupplierMapping ASM where ASM.isActive=1 AND ASM.Country=@Country and ASM.UserType=@UserType and ASM.AgencyName='All'  and ASM.Product='Air'      
  --select * from mCommon where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and UPPER(Value)=UPPER(@VendorName)      
  select * from mVendor where ID in (SELECT Data FROM sample_split(@VendorId, ',')) and REPLACE(UPPER(VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '')      
 end      
END   
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorByAgencyId] TO [rt_read]
    AS [dbo];

