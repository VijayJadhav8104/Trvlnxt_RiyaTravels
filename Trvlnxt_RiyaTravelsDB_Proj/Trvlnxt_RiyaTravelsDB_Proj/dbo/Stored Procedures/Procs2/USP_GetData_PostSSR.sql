--sp_helptext USP_GetData_PostSSR
CREATE PROCEDURE [dbo].[USP_GetData_PostSSR]  --USP_GetData_PostSSR 'VFN123'                                 
	@PNR varchar(20)                           
AS                                     
BEGIN                                     
                                  
DECLARE @RiyaPNR VARCHAR(10)                                  
                                    
 set @RiyaPNR=(SELECT top 1 BM.riyaPNR FROM tblBookMaster BM                                   
  INNER JOIN tblBookItenary BI ON BI.fkBookMaster=BM.pkId                                   
  WHERE BM.riyaPNR=@PNR or BI.airlinePNR=@PNR or BM.GDSPNR=@PNR)                                  
                                  
   declare @adtcount int=0,@chdcount int=0    
   IF NOT EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM  
    INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId  
    WHERE BM.riyaPNR = @RiyaPNR AND PB.isReturn = 0  
)  
BEGIN  
         
    select @adtcount=count(*) from  tblPassengerBookDetails                                       
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR)                                      
  and (paxType  ='ADULT' or paxType='ADT') and isReturn=1                                      
 select @chdcount=count(*) from  tblPassengerBookDetails                                       
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR )                                      
  and (paxType  ='CHILD' or paxType='CHD')  and isReturn=1      
END  
ELSE  
BEGIN  
    -- Run the original query  
    select @adtcount=count(*) from  tblPassengerBookDetails                                       
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR)                                      
  and (paxType  ='ADULT' or paxType='ADT') and isReturn=0                                      
 select @chdcount=count(*) from  tblPassengerBookDetails                                       
  where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR )                                      
  and (paxType  ='CHILD' or paxType='CHD')  and isReturn=0      
END  
 -- select @adtcount=count(*) from  tblPassengerBookDetails                                       
 -- where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR)                                      
 -- and (paxType  ='ADULT' or paxType='ADT') and isReturn=0                                      
 --select @chdcount=count(*) from  tblPassengerBookDetails                                       
 -- where fkBookMaster in(select pkId from tblBookMaster where riyaPNR =@RiyaPNR )                                      
 -- and (paxType  ='CHILD' or paxType='CHD')  and isReturn=0                         
 --Table 1.fetch Header data START                                    
                                    
 SELECT BM.riyaPNR
 ,BM.GDSPNR
 ,BI.airlinePNR
 ,BM.inserteddate_old 
 ,CASE WHEN Lower(BM.VendorName) in  ('airasia','air india express','aiexpress','akasaair','spicejet','allianceair','indigo','jazeera','ekndc','airasiaintl', 'wyndc', 'sabre', 'Verteil', 'VerteilNDC','flydubai') then 'APIOUT' else BM.VendorName  end as VendorName 
 ,BM.OfficeID
 ,BM.AgentROE
 ,BM.ROE
 ,BM.AgentCurrency
 ,MainAgentId
 ,AgentID
 ,BM.VendorName As VendorNameNew
 --,VC.Currency AS 'BaseCurrency'
 ,mVendorCredential.Value AS 'BaseCurrency'
 ,@adtcount as noOfAdult
 ,@chdcount as noOfChild                               
 ,BM.orderId
 ,mCommon.Value AS AgentDisplayCurrency
 FROM tblBookMaster BM                                     
 INNER JOIN tblBookItenary BI ON BI.fkBookMaster = BM.pkId                                     
 --INNER JOIN mCountry VC ON VC.CountryCode=BM.Country    
 INNER JOIN mVendorCredential ON mVendorCredential.OfficeId = BM.OfficeID AND FieldName = 'CURRENCY'
INNER JOIN agentLogin ON agentLogin.UserID = BM.AgentID
LEFT JOIN mCommon ON mCommon.ID = agentLogin.NewCurrency
 WHERE BM.riyaPNR=@RiyaPNR  and  BM.BookingStatus !=18                                  
                                
 --Table 1.fetch Header data END                                    

 --Table 2 .User Details START                                    
                                    
 SELECT BM.mobileNo,BM.emailId ,BM.airCode                                   
 FROM tblBookMaster BM   where bm.riyaPNR=@RiyaPNR AND BM.BookingStatus !=18                                      
                                    
 --Table 2 .User Details END                                    
                                    
 --Table 3. Passanger Details STATRT                                    
  
 IF NOT EXISTS (  
    SELECT 1  
    FROM tblBookMaster BM  
    INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId  
    WHERE BM.riyaPNR = @RiyaPNR AND PB.isReturn = 0  
)  
BEGIN  
    -- Run the same query but with PB.isReturn = 1  
    SELECT PB.title, PB.paxFName, PB.paxLName, PB.ticketNum,        
        (REPLACE(CONVERT(VARCHAR(20), PB.dateOfBirth, 106), ' ', '-')) AS 'dateOfBirth',                              
        PB.baggage, PB.paxType, PB.isReturn, PB.fkBookMaster, PB.pid,                          
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'seat'   
        FOR XML PATH('')), 1, 1, '')) AS 'seat',                         
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'baggage'   
        FOR XML PATH('')), 1, 1, '')) AS 'baggage',                       
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'meal'   
        FOR XML PATH('')), 1, 1, '')) AS 'meal'                          
    FROM tblBookMaster BM                                     
    INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId   
    WHERE BM.riyaPNR = @RiyaPNR AND PB.isReturn = 1  AND BM.BookingStatus !=18  
    ORDER BY PB.pid;  
END  
ELSE  
BEGIN  
    -- Run the original query  
    SELECT PB.title, PB.paxFName, PB.paxLName, PB.ticketNum,        
        (REPLACE(CONVERT(VARCHAR(20), PB.dateOfBirth, 106), ' ', '-')) AS 'dateOfBirth',                              
        PB.baggage, PB.paxType, PB.isReturn, PB.fkBookMaster, PB.pid,                          
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'seat'   
        FOR XML PATH('')), 1, 1, '')) AS 'seat',                         
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'baggage'   
        FOR XML PATH('')), 1, 1, '')) AS 'baggage',                       
        (SELECT STUFF((SELECT '/' + SSR_Code    
        FROM tblSSRDetails ssr                
        WHERE ssr.fkBookMaster = PB.fkBookMaster   
            AND ssr.fkPassengerid = PB.pid   
            AND ssr.SSR_Type = 'meal'   
        FOR XML PATH('')), 1, 1, '')) AS 'meal'                          
    FROM tblBookMaster BM                                     
    INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId   
    WHERE BM.riyaPNR = @RiyaPNR AND PB.isReturn = 0   AND BM.BookingStatus !=18 
    ORDER BY PB.pid;  
END  
  
-- SELECT PB.title,PB.paxFName,PB.paxLName,PB.ticketNum,        
-- (REPLACE(CONVERT(VARCHAR(20),PB.dateOfBirth,106),' ','-')) AS 'dateOfBirth',                              
-- PB.baggage ,PB.paxType , PB.isReturn,fkBookMaster,pid                         
--  , (SELECT STUFF((SELECT '/' + SSR_Code  FROM tblSSRDetails ssr                
-- where ssr.fkBookMaster = PB.fkBookMaster and ssr.fkPassengerid = pb.pid and ssr.SSR_Type = 'seat' FOR XML PATH('')),1,1,'')) AS 'seat'                         
--, (SELECT STUFF((SELECT '/' + SSR_Code  FROM tblSSRDetails ssr                
-- where ssr.fkBookMaster = PB.fkBookMaster and ssr.fkPassengerid = pb.pid and ssr.SSR_Type = 'baggage' FOR XML PATH('')),1,1,'')) AS 'baggage'                        
--,(SELECT STUFF((SELECT '/' + SSR_Code  FROM tblSSRDetails ssr                
-- where ssr.fkBookMaster = PB.fkBookMaster and ssr.fkPassengerid = pb.pid and ssr.SSR_Type = 'meal' FOR XML PATH('')),1,1,'')) AS 'meal'                          
-- FROM tblBookMaster BM                                     
-- INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster=BM.pkId where bm.riyaPNR=@RiyaPNR AND PB.isReturn=0  order by pid                         
                                    
 --Table 3. Passanger Details END                                    
                                    
 --Table 4. Travel Details START                                    
                                 
 SELECT BI.airName,BI.cabin,BI.frmSector,BI.toSector,BI.deptTime,BI.arrivalTime,BI.flightNo ,BI.fkBookMaster             
 ,BM.frmSector as FromLocation,BM.toSector as ToLocation, BM.deptTime as OriginTime ,BM.arrivalTime as DestinationTime            
 FROM tblBookMaster BM                                     
 INNER JOIN tblBookItenary BI ON BI.fkBookMaster = BM.pkId                                     
 WHERE BM.riyaPNR=@RiyaPNR AND BM.BookingStatus !=18 order by BI.pkId asc                       
                                    
 --Table 4. Travel Details END                              
                           
SELECT BI.frmSector,BI.toSector ,BI.airCode+' '+ BI.flightNo as 'flightNo'                          
,PB.paxFName +' ' +PB.paxLName AS 'PaxName'                          
,SSR_Code,SSR_Type,SSR_Name  ,pb.paxType          
 FROM   tblBookMaster BM                                     
 INNER JOIN tblBookItenary BI ON BI.fkBookMaster = BM.pkId                         
 INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId                            
 inner join tblSSRDetails ssr on ssr.fkItenary=BI.pkId   and ssr.fkPassengerid=PB.pid                             
 WHERE BM.riyaPNR=@RiyaPNR  AND BM.BookingStatus !=18  and SSR_Code is not null                       
        --and SSR_Type!='Meals'     and SSR_Type!='Baggage'                     
                                    
                               
END 