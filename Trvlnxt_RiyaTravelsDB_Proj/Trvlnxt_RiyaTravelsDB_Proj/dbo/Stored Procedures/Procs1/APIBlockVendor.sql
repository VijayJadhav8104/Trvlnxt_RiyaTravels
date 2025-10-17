    
CREATE Procedure APIBlockVendor    
@VendorName varchar(20) = ''    
,@UserType varchar(20) = ''    
,@Country varchar(20) = ''    
    
AS    
BEGIN    
    
SELECT bv.ID,    
    v.VendorName,    
    c.Value as 'UserType',    
    bv.Country,    
    bv.OfficeId,    
    bv.AirlineCode,    
    bv.ApiIndicator,    
    bv.BlockAvailability,    
    bv.BlockSell,    
    bv.BlockBooking,    
    FareTypeId,    
    (select stuff((select ',' + far.FareName from mFareTypeByAirline far    
    where PATINDEX('%,'+convert(varchar,far.ID)+',%',','+bv.FareTypeId+',')>0    
    for xml path('')),1,1,'')) as FareType,    
    AgencyId,    
    case when bv.AgencyId='0' then 'ALL' else (select stuff((select ',' + b.AgencyName from AgentLogin agt    
    left join B2BRegistration b on b.FKUserID=agt.UserID     
    where PATINDEX('%,'+convert(varchar,agt.UserID)+',%',','+bv.AgencyId+',')>0    
    for xml path('')),1,1,'')) end as AgencyName    
    from mBlockVendor bv        
    inner join mVendor v on bv.VendorId=v.ID    
    inner join mCommon c on bv.UserTypeId=c.ID        
    where bv.IsActive=1 and v.IsActive=1 and v.IsDeleted=0    
 and v.VendorName = @VendorName    
 and c.Value = @UserType    
 and bv.Country = @Country  
       
 END