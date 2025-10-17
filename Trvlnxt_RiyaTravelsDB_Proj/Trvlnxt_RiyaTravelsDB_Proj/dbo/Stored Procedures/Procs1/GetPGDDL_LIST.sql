CREATE pROC  GetPGDDL_LIST     
@AgentId varchar(20)=''    
    
AS    
    
BEGIN    
    
Select PGM.Mode as 'Mode', Convert(varchar, PGM.charges) + '$'+  Convert(varchar, PGM.Vat) as ChargesVat    
from PGAgentMappingHotel PGAM     
join PaymentGatewayMode PGM on PGAM.PGID=PGM.PGID     
where PGAM.Agentid=@AgentId    
       
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPGDDL_LIST] TO [rt_read]
    AS [dbo];

