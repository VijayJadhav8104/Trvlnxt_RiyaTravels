      
CREATE proc [dbo].[GetHistory_ServiceFee_GST_Quatation]      
@UserId INT,     
 @FromDate   datetime,      
 @ToDate  datetime,    
 @Start int=null,      
 @Pagesize int=null,     
 @RecordCount INT OUTPUT     
as      
begin      
   IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL      
 DROP table  #tempTableA      
 SELECT * INTO #tempTableA       
 from      
 (         
select q.*,Value as QuatationValue,     
(CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],      
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],      
 U.Username,       
q.AgencyNames As [AgentName]      
 from tbl_ServiceFee_GST_QuatationDetailsDelete q      
      
left outer join mCommon m on q.Quatation=m.ID      
left join mUser u ON U.ID=Q.DeletedBy      
      
where q.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM      
   INNER JOIN mCountry C ON C.ID=UM.CountryId     
   where     
   UserID=@UserId AND     
   IsActive=1)     
   and q.UserType in (select mc.Value from mUserTypeMapping UT      
 inner join mCommon mc on mc.ID=UT.UserTypeId      
  where ut.UserId=@UserId and UT.IsActive=1)        
 and  CONVERT(date,q.DeletedOn) >= CONVERT(date,@FromDate)        
  and CONVERT(date,q.DeletedOn) <= CONVERT(date,@ToDate)      
) p    
    
ORDER BY  p.ID DESC     
    
SELECT @RecordCount = @@ROWCOUNT      
      
  SELECT * FROM #tempTableA      
  ORDER BY  DeletedOn desc      
  OFFSET @Start ROWS      
  FETCH NEXT @Pagesize ROWS ONLY     
      
end 