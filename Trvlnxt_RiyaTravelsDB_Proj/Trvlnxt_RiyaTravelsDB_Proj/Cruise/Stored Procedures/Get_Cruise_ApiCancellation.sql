CREATE PROCEDURE  [Cruise].[Get_Cruise_ApiCancellation]    
  --@ID int=0,    
 --@AgentId int=0,    
 @SupplierId varchar(30)=NULL,    
 @FromDate varchar(50)= null,    
 @ToDate varchar(50)=null     
AS    
BEGIN    
    
select * from Cruise.tblCruise_Cancellation CC    
where    
         --(@AgentId=null or (cc.AgentId=@AgentId)) and   
      (@SupplierId='' or (cc.SupplierId LIKE '%'+ @SupplierId +'%'))    
        
   and ((@FromDate='') or (cc.Fromdate>=CONVERT(DATE, @FromDate))) ---cast(@FromDate as Date)))    
   -- and (Convert(varchar(12),cc.Fromdate,102) between Convert(varchar(12),Convert(datetime,@FromDate,103),102) and                            
   --case when @FromDate <> '' then Convert(varchar(12),Convert(datetime,@FromDate,103),102)else Convert(varchar(12),Convert(datetime,@FromDate,103),102) end or (@FromDate='' and @FromDate=''))                            
            
   and ((@ToDate='') or (cc.ToDate<=CONVERT(DATE, @ToDate)))  --cast(@ToDate as date)))    
    
   -- and (Convert(varchar(12),cc.ToDate,102) between Convert(varchar(12),Convert(datetime,@ToDate,103),102) and                            
   --case when @ToDate <> '' then Convert(varchar(12),Convert(datetime,@ToDate,103),102)else Convert(varchar(12),Convert(datetime,@ToDate,103),102) end or (@ToDate='' and @ToDate=''))                            
            
    
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[Get_Cruise_ApiCancellation] TO [rt_read]
    AS [DB_TEST];

