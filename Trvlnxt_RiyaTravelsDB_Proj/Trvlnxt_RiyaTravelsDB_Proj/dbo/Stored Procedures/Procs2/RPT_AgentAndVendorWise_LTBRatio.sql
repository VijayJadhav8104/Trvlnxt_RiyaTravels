  
CREATE PROCEDURE [dbo].[RPT_AgentAndVendorWise_LTBRatio]      
 @Date DATETIME  
  
AS  
begin


--1. Agency Wise Count Search Sell And Book
select  
br.AgencyName as [Agent Name],  
count(tsb.status) as Searches,
count(case when (tsb.status='Sell'  or tsb.status='Book') then 1 end) as Sell,
count(case when tsb.status='Book' then 1 end) as Book
from tblSearchSellBookDetails   tsb WITH(NOLOCK)
inner join B2BRegistration br WITH(NOLOCK) on tsb.AgentID=br.fkuserid
where CONVERT(DATE, EntryDate) = CONVERT(DATE,@Date)  
group by br.AgencyName
order by br.AgencyName


--2. Vendor And Office Id Wise Count
select 
mv.VendorName as [Vendor Name],
mvc.OfficeId as OfficeId,
count(tsb.status) as Searches,
count(case when (tsb.status='Sell'  or tsb.status='Book') then 1 end) as Sell,
count(case when tsv.Caching=1 then 1 end)  as Caching,
count(case when tsv.Caching=0 then 1 end) as Direct,
count(case when tsb.status='Book' then 1 end) as Book
from tblSearchSellBookDetails tsb WITH(NOLOCK) 
inner join tblSearchVendorDetails tsv WITH(NOLOCK) on tsv.TrackingID = tsb.TrackingID and tsv.OfficeID=tsb.OfficeID
inner join mVendorCredential mvc WITH(NOLOCK) on mvc.OfficeId = tsv.OfficeID and  mvc.FieldName='OID Name' and mvc.IsActive=1
inner join mVendor mv WITH(NOLOCK) on mv.ID=mvc.VendorId
where CONVERT(DATE, tsb.EntryDate) = CONVERT(DATE,@Date)
and  mvc.FieldName='OID Name' 
and mv.IsDeleted=0
group by mv.VendorName,
mvc.OfficeId
order by mv.VendorName


end

