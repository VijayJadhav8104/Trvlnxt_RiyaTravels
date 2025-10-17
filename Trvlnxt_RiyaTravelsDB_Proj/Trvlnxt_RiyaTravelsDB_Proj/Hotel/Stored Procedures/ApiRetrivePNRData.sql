  
  
      
----------------------------        
-- Created By : Akash Singh        
-- Date : 06/10/2023        
-- Desc : To insert Amadeus Retrive PNR Date         
-- Exe  : [Hotel].ApiRetrivePNRData 'NEwTest121212','session&securityToken&1','BOM213344','54543'        
----------------------------        
CREATE Proc [Hotel].[ApiRetrivePNRData]        
@Pnr varchar(200)=null,        
@SST varchar(max)=null,  --ControlNumber +&+ Sesstion + & + Secuity Token + & + RefrenceNumber        
@OfficeId varchar(200)=null,        
@AgentId varchar(100)=null,
@Currency varchar(100)=null,
@Amount decimal(18,2)=null, 
@CancellationToken varchar(100)=null  
AS         
BEGIN        
       
 IF NOT EXISTS  (select * from  Hotel.tblApiRetrivePNRData where PNR=@Pnr)      
 BEGIN      
  insert into  Hotel.tblApiRetrivePNRData       
  (PNR,OfficeId,SSTS,AgentId,UpdatedDate,Currency,Amount, CancellationToken)  values      
  (@Pnr,@OfficeId,@SST,@AgentId,GetDate(),@Currency,@Amount, @CancellationToken)       
 END      
 ELSE      
    BEGIN      
      update [hotel]. tblApiRetrivePNRData set       
   PNR=@Pnr,       
   OfficeId=@OfficeId,       
   SSTS=@SST,       
   AgentId=@AgentId,      
   UpdatedDate=GetDate(),
   Currency=@Currency,
   Amount=@Amount,
   CancellationToken=@CancellationToken
   where PNR=@Pnr
 END      
END   
  