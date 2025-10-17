
-- =============================================
-- Author:	Nitish/Akash
-- Create date: 20-June-2022
-- Description:	To SightSeeing CancellationDetails
-- SS.Get_SightSeeing_ApiCancellation 0,0,'',''
-- =============================================
CREATE PROCEDURE [SS].[Get_SightSeeing_ApiCancellation]
  --@ID int=0,
	@AgentId int=0,
	@SupplierId int=0,
	@FromDate varchar(50)='',
	@ToDate varchar(50)=''
AS
BEGIN

select * from SS.tbl_Cancellation CC
where
         (@AgentId=null or (cc.AgentId=@AgentId))
   and   (@SupplierId=0 or (cc.SupplierId=@SupplierId))
    
   and ((@FromDate='') or (cc.Fromdate>=CONVERT(DATE, @FromDate)))
   -- and (Convert(varchar(12),cc.Fromdate,102) between Convert(varchar(12),Convert(datetime,@FromDate,103),102) and                        
   --case when @FromDate <> '' then Convert(varchar(12),Convert(datetime,@FromDate,103),102)else Convert(varchar(12),Convert(datetime,@FromDate,103),102) end or (@FromDate='' and @FromDate=''))                        
        
   and ((@ToDate='') or (cc.ToDate<=CONVERT(DATE, @ToDate)))

   -- and (Convert(varchar(12),cc.ToDate,102) between Convert(varchar(12),Convert(datetime,@ToDate,103),102) and                        
   --case when @ToDate <> '' then Convert(varchar(12),Convert(datetime,@ToDate,103),102)else Convert(varchar(12),Convert(datetime,@ToDate,103),102) end or (@ToDate='' and @ToDate=''))                        
        

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[Get_SightSeeing_ApiCancellation] TO [rt_read]
    AS [DB_TEST];

