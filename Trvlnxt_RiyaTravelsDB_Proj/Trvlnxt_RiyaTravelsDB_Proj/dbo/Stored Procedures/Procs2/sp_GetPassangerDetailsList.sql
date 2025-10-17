CREATE Procedure [dbo].[sp_GetPassangerDetailsList]     --sp_GetPassangerDetailsList 'LGUXYL'         
@GDSPNR varchar(50) = null            
as              
begin              
            
Select p.pid,LTRIM(RTRIM(p.paxFName)) as paxFName,LTRIM(RTRIM(p.paxLName)) as paxLName,LTRIM(RTRIM(p.paxType)) as paxType,          
p.IATACommission,p.PLBCommission,p.DropnetCommission,p.Markup,p.MCOAmount,p.BFC ,p.title    
,b.frmSector  
,(Select top 1 toSector from tblBookMaster as tblbooktosector   
where b.riyaPNR =tblbooktosector.riyaPNR and tblbooktosector.GDSPNR = @GDSPNR order by tblbooktosector.pkId desc) as toSector
,p.ServiceFee,p.GST
From tblPassengerBookDetails p inner join tblBookmaster b on b.pkId = p.fkBookMaster where b.GDSPNR = @GDSPNR AND p.basicFare <> 0        
      
Select SUM(ServiceFee + GST) as ServiceGSTTotal from tblBookMaster where GDSPNR = @GDSPNR      
            
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetPassangerDetailsList] TO [rt_read]
    AS [dbo];

