CREATE proc [dbo].[GetHistory_ROE]        
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
 U.Username,         
q.AgencyNames As [AgentName]        
 from mAgentROE_ConsoleHistory q        
             
left join mUser u ON U.ID=Q.CreatedBy                
 and q.UserType in (select mc.Value from mUserTypeMapping UT        
 inner join mCommon mc on mc.ID=UT.UserTypeId        
  where ut.UserId=@UserId and UT.IsActive=1)          
 and  CONVERT(date,q.CreatedOn) >= CONVERT(date,@FromDate)          
  and CONVERT(date,q.CreatedOn) <= CONVERT(date,@ToDate)        
) p      
      
ORDER BY  p.ID DESC       
      
SELECT @RecordCount = @@ROWCOUNT        
        
  SELECT * FROM #tempTableA        
  ORDER BY  CreatedOn desc        
  OFFSET @Start ROWS        
  FETCH NEXT @Pagesize ROWS ONLY       
        
end   
  