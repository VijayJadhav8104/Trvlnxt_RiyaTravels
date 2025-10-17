    
 -- [GetROEReport] '05/01/2021' , '06/01/2021'        
         
CREATE proc [dbo].[GetROEReport]            
 @fromdate varchar(20)  ,          
@todate varchar(20)            
as           
Begin          
SELECT  FromCur,           
Case when FromCur='INR' then '1' else round(INR,6) end  as INR          
,Case when FromCur='USD' then '1' else round(USD,6) end USD          
,Case when FromCur='AED' then '1' else round(AED,6) end AED          
,Case when FromCur='CAD' then '1' else round(CAD,6) end CAD      
,InserDate    
--,Case when FromCur='QAR' then '1' else round(QAR,2) end QAR          
          
FROM            
(          
  SELECT FromCur,ToCur,ROE,convert(varchar ,inserdate, 106)as InserDate        
  FROM ROE where  cast(InserDate as date) between @fromdate and @todate --and IsActive=1          
  and  FromCur in ('INR'  ,'USD'  ,'AED')         
) AS SourceTable            
PIVOT            
(            
  Max(ROE)          
  FOR ToCur IN (          
 INR          
,USD          
,AED          
,CAD)         
--,QAR)            
) AS PivotTable;     
          
End 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetROEReport] TO [rt_read]
    AS [dbo];

