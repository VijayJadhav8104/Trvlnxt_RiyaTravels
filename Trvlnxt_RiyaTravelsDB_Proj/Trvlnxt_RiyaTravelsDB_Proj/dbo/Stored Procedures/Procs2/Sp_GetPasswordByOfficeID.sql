
CREATE Procedure [dbo].[Sp_GetPasswordByOfficeID]    --'INTDXBA122'  
@OfficeId nvarchar(50)=null      
      
as      
begin      
  select top 1 value as Password from mVendorCredential where OfficeId=@OfficeId and     
  FieldName='Password'    and IsActive=1  order by CreatedOn desc
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetPasswordByOfficeID] TO [rt_read]
    AS [dbo];

