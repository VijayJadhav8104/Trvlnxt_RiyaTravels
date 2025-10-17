    
CREATE PROCEDURE [dbo].[Sp_GetROEUpdation]     
 @Type varchar(10)=null,    
 @Userid int,    
 @CountryId int,    
 @UserTypeId int,    
 @GDSTypeId int,    
 @OfficeId varchar(100),  
  @AgentId int    
AS    
BEGIN    
 if(@Type='ROE')    
 BEGIN    
 select updation.ID,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,    
   isnull(comm5.Value,vendor.VendorName) as GDSType,country.CountryName as Country ,airline._NAME as AirLine    
   ,updation.OfficeIdText as OfficeId ,    
   muser.UserName as ModifiedBy,FORMAT(updation.ModifiedOn, 'dd-MMM-yyyy') as 'ModifiedOn',muser1.UserName as CreatedBy ,
   FORMAT(updation.CreatedOn, 'dd-MMM-yyyy') as 'CreatedOn',    
   updation.Flag, updation.MarkupType, updation.MarkupData, updation.IsAddSubtract, updation.IsROEMarkup, updation.MarkupAmount, updation.VendorROE    
   ,STUFF((SELECT ', ' + mROEAgencyMapping.AgencyName    
              FROM mROEAgencyMapping    
              WHERE mROEAgencyMapping.ROEId = updation.ID    
              FOR XML PATH('')), 1, 2, '') AS AgencyNames    
 from mROEUpdation updation    
 left join mCommon comm1 on updation.UserTypeId=comm1.ID    
 left join mCommon comm2  on updation.ProductId=comm2.ID    
 left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID    
 left join mCommon comm4  on updation.ToCurrencyId=comm4.ID    
 left join mCommon comm5  on updation.GDSTypeId=comm5.ID    
 left join mCountry country on updation.CountryId=country.ID    
 left join AirlinesName airline on updation.AirLineId=airline.ID    
 --left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid    
 left join mUser muser on muser.ID=updation.ModifiedBy    
 inner join mUser muser1 on muser1.ID=updation.CreatedBy    
 left join mVendor vendor on updation.VendorId=vendor.ID    
 where updation.IsActive=1    
 and updation.UserTypeId in (select UserTypeId  from mUserTypeMapping UM where UserID=@Userid)    
 and updation.CountryId in (select CountryId  from mUserCountryMapping UM where UserID=@Userid)    
    
 END    
  ELSE IF (@Type='Filter') and (@AgentId != 0)           
 BEGIN            
  SELECT updation.ID,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,            
  isnull(comm5.Value,vendor.VendorName) as GDSType,country.CountryName as Country ,airline._NAME as AirLine,tblComm.CategoryValue as OfficeId ,            
  muser.UserName as ModifiedBy,
   FORMAT(updation.ModifiedOn, 'dd-MMM-yyyy') as 'ModifiedOn',
  muser1.UserName as CreatedBy ,
  FORMAT(updation.CreatedOn, 'dd-MMM-yyyy') as 'CreatedOn',            
  updation.Flag,updation.MarkupType, updation.MarkupData, updation.IsAddSubtract, updation.IsROEMarkup, updation.MarkupAmount, updation.VendorROE,            
  STUFF((SELECT ', ' + mROEAgencyMapping.AgencyName            
              FROM mROEAgencyMapping            
              WHERE mROEAgencyMapping.ROEId = updation.ID            
              FOR XML PATH('')), 1, 2, '') AS AgencyNames            
  from mROEUpdation updation            
  left join mCommon comm1 on updation.UserTypeId=comm1.ID            
  left join mCommon comm2  on updation.ProductId=comm2.ID            
  left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID            
  left join mCommon comm4  on updation.ToCurrencyId=comm4.ID            
  left join mCommon comm5  on updation.GDSTypeId=comm5.ID            
  left join mCountry country on updation.CountryId=country.ID            
  left join AirlinesName airline on updation.AirLineId=airline.ID            
  left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid            
  left join mUser muser on muser.ID=updation.ModifiedBy            
  inner join mUser muser1 on muser1.ID=updation.CreatedBy            
  left join mVendor vendor on updation.VendorId=vendor.ID            
  left join mROEAgencyMapping re on re.ROEId = updation.ID          
  left join B2BRegistration be on be.PKID=re.AgencyId           
  where updation.IsActive=1              
  AND ((@CountryId = 0) or  (updation.CountryId=@CountryId))            
  AND ((@UserTypeId = 0) or  (updation.UserTypeId=@UserTypeId))            
  AND ((@GDSTypeId = 0) or  (vendor.ID=@GDSTypeId))            
  AND ((@OfficeId = '') or  (updation.OfficeIdText=@OfficeId))           
  and be.FKUserID =@AgentID          
  --and re.AgencyName like '%' + @AgentName + '%'          
 END      
 ELSE IF (@Type='Filter')  and (@AgentId = 0)   
 BEGIN    
 select updation.ID,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,    
   isnull(comm5.Value,vendor.VendorName) as GDSType,country.CountryName as Country ,airline._NAME as AirLine    
   ,updation.OfficeIdText as OfficeId ,    
   muser.UserName as ModifiedBy,
   FORMAT(updation.ModifiedOn, 'dd-MMM-yyyy') as 'ModifiedOn',
   muser1.UserName as CreatedBy ,
   FORMAT(updation.CreatedOn, 'dd-MMM-yyyy') as 'CreatedOn',    
   updation.Flag, updation.MarkupType, updation.MarkupData, updation.IsAddSubtract, updation.IsROEMarkup, updation.MarkupAmount, updation.VendorROE,    
   STUFF((SELECT ', ' + mROEAgencyMapping.AgencyName    
              FROM mROEAgencyMapping    
              WHERE mROEAgencyMapping.ROEId = updation.ID    
              FOR XML PATH('')), 1, 2, '') AS AgencyNames    
 from mROEUpdation updation    
 left join mCommon comm1 on updation.UserTypeId=comm1.ID    
 left join mCommon comm2  on updation.ProductId=comm2.ID    
 left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID    
 left join mCommon comm4  on updation.ToCurrencyId=comm4.ID    
 left join mCommon comm5  on updation.GDSTypeId=comm5.ID    
 left join mCountry country on updation.CountryId=country.ID    
 left join AirlinesName airline on updation.AirLineId=airline.ID    
 --left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid    
 left join mUser muser on muser.ID=updation.ModifiedBy    
 inner join mUser muser1 on muser1.ID=updation.CreatedBy    
 left join mVendor vendor on updation.VendorId=vendor.ID    
 where updation.IsActive=1      
  AND ((@CountryId = 0) or  (updation.CountryId=@CountryId))    
  AND ((@UserTypeId = 0) or  (updation.UserTypeId=@UserTypeId))    
  AND ((@GDSTypeId = 0) or  (vendor.ID=@GDSTypeId))    
  AND ((@OfficeId = '') or  (updation.OfficeIdText=@OfficeId))    
 END    
 ELSE    
 BEGIN    
 select updation.ID,updation.Action,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,    
   isnull(comm5.Value,vendor.VendorName) as GDSType,    
   country.CountryName as Country     
   ,updation.OfficeIdText as OfficeId ,    
   updation.AirLineId,updation.IsAllAirline,updation.AgencyId,updation.IsAllAgency,muser.UserName as ModifiedBy,
  FORMAT(updation.ModifiedOn, 'dd-MMM-yyyy') as 'ModifiedOn',updation.CountryId,    
   updation.Flag    
 from mROEUpdationHistory updation    
 left join mCommon comm1 on updation.UserTypeId=comm1.ID    
 left join mCommon comm2  on updation.ProductId=comm2.ID    
 left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID    
 left join mCommon comm4  on updation.ToCurrencyId=comm4.ID    
 left join mCommon comm5  on updation.GDSTypeId=comm5.ID    
 left join mCountry country on updation.CountryId=country.ID    
 left join mVendor vendor on updation.VendorId=vendor.ID    
 --left join AirlinesName airline on updation.AirLineId=airline.ID    
 --left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid    
 inner join mUser muser on muser.ID=updation.ModifiedBy    
    
 where updation.UserTypeId in (select UserTypeId  from mUserTypeMapping UM where UserID=@Userid)    
 and updation.CountryId in (select CountryId  from mUserCountryMapping UM where UserID=@Userid)    
 order by updation.ModifiedOn desc    
    
 END    
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetROEUpdation] TO [rt_read]
    AS [dbo];

