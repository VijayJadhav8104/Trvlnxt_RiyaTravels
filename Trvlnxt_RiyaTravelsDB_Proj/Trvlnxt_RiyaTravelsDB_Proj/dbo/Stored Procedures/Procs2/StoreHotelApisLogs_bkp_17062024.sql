-- =============================================                      
-- Author:  <Akash Singh>                      
-- Create date: <17-11-2022>                      
-- Description: <Insert Apis Logs>                      
-- =============================================                      
 CREATE Proc StoreHotelApisLogs_bkp_17062024                       
 @URL varchar(200)='',                      
 @Request varchar(max)='',                      
 @Response varchar(max)='',                       
 @Header varchar(max)='',                      
 @MethodName varchar(max)='',                    
 @CorrelationId varchar(max)='',                   
 @AgentId varchar(max)='',                
 @Timmer varchar(max)='',              
 @IP varchar(100)='',          
 @token varchar(1000)='',         
 @ServerIp varchar(200)='',    
 @rateCodes varchar(200)='',    
 @officeId varchar(200)='',    
 @CustomerId varchar(200)='',    
 @HGToken varchar(200)='',    
 @HGRateCodes varchar(200)='',  
 @BookingPortal varchar(50)=''  
 AS                      
 BEGIN                      
                          
    insert into [AllAppLogs].[dbo].hotelapilogs(URL,Request,Response,Header,MethodName,InsertedDate,CorrelationId,AgentId,Timmer,IP,Token,ServerIp,rateCodes,officeId,CustomerId,HGToken,HGRateCodes,BookingPortal)                       
                      values  (@URL,@Request,@Response,@Header,@MethodName,GetDate(),@CorrelationId,@AgentId,@Timmer,@IP,@token,@ServerIp,@rateCodes,@officeId,@CustomerId,@HGToken,@HGRateCodes,@BookingPortal)                      
                      
 END   
  