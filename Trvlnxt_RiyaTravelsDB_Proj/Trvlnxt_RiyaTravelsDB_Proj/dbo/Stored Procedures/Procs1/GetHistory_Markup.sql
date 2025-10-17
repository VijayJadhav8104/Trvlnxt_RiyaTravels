            
CREATE proc [dbo].[GetHistory_Markup]            
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
select q.*,           
(CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],            
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],            
 U.Username,             
q.name As [AgentName]            
 from Flight_MarkupTypeHistory q            
           
left join mUser u ON U.ID=Q.Userid            
            
where q.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM            
   INNER JOIN mCountry C ON C.ID=UM.CountryId           
   where           
   UserID=@UserId AND           
   IsActive=1)           
                
 and  CONVERT(date,q.UpdatedDate) >= CONVERT(date,@FromDate)              
  and CONVERT(date,q.UpdatedDate) <= CONVERT(date,@ToDate)            
) p          
          
ORDER BY  p.ID DESC           
          
SELECT @RecordCount = @@ROWCOUNT            
            
  SELECT * FROM #tempTableA            
  ORDER BY  UpdatedDate desc            
  OFFSET @Start ROWS            
  FETCH NEXT @Pagesize ROWS ONLY           
            
end       
    
    