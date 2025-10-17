-- =============================================                                          
-- Author:  <Author,,Name>                                          
-- Create date: <Create Date,,>                                          
-- Description: <Description,,>                                          
-- =============================================                                          
CREATE PROCEDURE  [dbo].[USPGetpromocode] -- '14398855E','bom','del','2023-11-08 10:11:39.043','6e','0'                    
@OfficeId varchar(50),                                          
@fromSector varchar(50),                                          
@ToSector varchar(50),                                          
@TrvlFrom date,                                          
@Carrier varchar(20),                                
@AgentID varchar(20)=NULL,                        
@GroupId int=0 ,          
@JourneyType varchar(10)=null          
AS                                          
BEGIN                                          
 --DECLARE                                          
 --if (SELECT count(*) FROM sectors s INNER JOIN tblPromoCode_trvlnxt t ON t.SectorExFrom=s.[Country Code]                                           
 --WHERE t.OfficeId=@OfficeId AND (s.Code=@fromSector or s.Code=@ToSector))=1                                          
                                        
 --remark below conditions only country wise                                         
 --if exists (SELECT * FROM sectors s INNER JOIN tblPromoCode_trvlnxt t ON t.SectorExFrom=s.[Country Code]                                           
 --WHERE t.OfficeId=@OfficeId AND (s.Code=@fromSector))                                          
 --BEGIN                                          
 -- SELECT * FROM tblPromoCode_trvlnxt                                           
 -- WHERE Salesfrom<=GETDATE() AND SalesTo>=GETDATE()                                          
 -- AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom                                           
 -- AND OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier                                          
 -- END                                          
  IF @Carrier='SG'                                      
  BEGIN                                 
   IF(@OfficeId='INTDXBA122')                                
  BEGIN                                
   SELECT * FROM tblPromoCode_trvlnxt                                           
     WHERE Salesfrom<=GETDATE() AND SalesTo>=GETDATE()                                          
     AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom                                           
     AND OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier                                         
     AND SectorExFrom=@fromSector-- (select top 1 COUNTRY from tblAirportCity where CODE=@fromSector)--@fromSector                           
  AND SectorExTo=@ToSector and @JourneyType !='RTS'--(select top 1 COUNTRY from tblAirportCity where CODE=@ToSector)                                      
  END                                
    ELSE IF(@OfficeId='BOMRTB6629')                                
    BEGIN                                
  if exists(SELECT PKID FROM tblPromoCode_trvlnxt                                          
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%')                                
      begin                                
   SELECT * FROM tblPromoCode_trvlnxt                                
   WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%'                                
   end                                
   else                                
   SELECT * FROM tblPromoCode_trvlnxt                                
   WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID ='0'                                
    END                               
 else if (@OfficeId='INTDXBCORP')                               
 Begin                              
  SELECT * FROM tblPromoCode_trvlnxt              
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1                               
 end                     
 else                    
 begin                     
 SELECT * FROM tblPromoCode_trvlnxt                                          
 WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%'                      
 end                    
  END                                
ELSE IF @Carrier='G8'                                      
BEGIN                                      
 SELECT * FROM tblPromoCode_trvlnxt                      
 WHERE Salesfrom<=GETDATE() AND SalesTo>=GETDATE()                                          
 AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom                                           
 AND OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier                                         
 AND SectorExFrom=@fromSector                         
 AND SectorExTo=(select top 1 COUNTRY from tblAirportCity where CODE=@ToSector)                                      
END                        
ELSE IF @Carrier='QP'                         
BEGIN      
if (@OfficeId='QPBOM5001H_01') 
begin
 if (SELECT DATEDIFF(day, GETDATE(), @TrvlFrom) AS DateDiffs) > 14
 begin
  
  SELECT * FROM tblPromoCode_trvlnxt                                
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier                        
  AND IsActive=1 AND Salesfrom<=GETDATE() AND SalesTo>=GETDATE()  
  AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom                                 
  
  end
  end
  else
  begin
   SELECT * FROM tblPromoCode_trvlnxt                                
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier                        
  AND IsActive=1 AND AgentID like '%' + @AgentID + '%'     
  end
END                         
ELSE IF @Carrier='I5'                        
BEGIN                         
 if @GroupId=3                        
  BEGIN                        
   SELECT * FROM tblPromoCode_trvlnxt                                
   WHERE OfficeId=@OfficeId AND Carrier=@Carrier                        
   AND IsActive=1 AND GroupId=@GroupId                        
  END                        
 ELSE                        
 BEGIN                        
  SELECT * FROM tblPromoCode_trvlnxt                                
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier                        
  AND IsActive=1 AND AgentID like '%' + @AgentID + '%'                         
 END                        
 END                  
ELSE IF @Carrier='6E' AND (@OfficeId='FAE0828' OR @OfficeId='14398855E')              
BEGIN               
 IF @OfficeId='FAE0828'              
 BEGIN              
  SELECT * FROM tblPromoCode_trvlnxt                                           
     WHERE Salesfrom<=GETDATE() AND SalesTo>=GETDATE()                                          
     AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom                                           
     AND OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier                                         
     AND SectorExFrom= @fromSector     --(select top 1 COUNTRY from tblAirportCity where CODE=@fromSector)--                      
  AND (SectorExTo= (select top 1 COUNTRY from tblAirportCity where CODE=@ToSector) OR SectorExTo=@ToSector)              
 END              
 ELSE IF  @OfficeId='14398855E'              
 BEGIN               
  SELECT * FROM tblPromoCode_trvlnxt               
  WHERE  OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier               
  AND Salesfrom<=GETDATE() AND SalesTo>=GETDATE()                                          
   AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom             
   AND SectorExFrom= (select top 1 COUNTRY from tblAirportCity where CODE=@fromSector)    
  AND SectorExTo= (select top 1 COUNTRY from tblAirportCity where CODE=@ToSector)    
    
 END              
END              
ELSE                                     
BEGIN                                   
 DECLARE @strAgentID VARCHAR(20)                                
 SELECT @strAgentID = AgentID FROM tblPromoCode_trvlnxt                                          
 WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1                                
 IF(@strAgentID is  null or @strAgentID ='')                                
 BEGIN                 
  SELECT * FROM tblPromoCode_trvlnxt                                          
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1                                  
 END                                
 ELSE                   
 BEGIN                                
   SELECT * FROM tblPromoCode_trvlnxt                                          
   WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%'                                
 END                                
END                       
                      
                      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetpromocode] TO [rt_read]
    AS [dbo];

