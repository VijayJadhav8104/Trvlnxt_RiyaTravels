  
CREATE proc [dbo].[GetPnrDetails]  --'4GKVBQ'
@pnr nvarchar(30)  
as   
begin  
select GDSPNR,Request,MethodName,Response from [AllAppLogs].[dbo].[PNRRetriveLogsAir]
where GDSPNR=@pnr --and MethodName not like '%web%'
end