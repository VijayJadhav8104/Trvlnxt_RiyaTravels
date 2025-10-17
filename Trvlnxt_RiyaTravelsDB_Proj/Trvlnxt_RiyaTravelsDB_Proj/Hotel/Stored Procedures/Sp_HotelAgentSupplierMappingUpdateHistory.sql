
cREATE pROC [hotel].Sp_HotelAgentSupplierMappingUpdateHistory
@AgentId int=0,
@UpdateBy int=0

AS
BEGIN
     
    update  [Hotel].HotelAgentSupplierMappingUpdation set isactive=0 where AgentId=@AgentId

     Insert into [Hotel].HotelAgentSupplierMappingUpdation
    (Agentid,UpdatedBy,Isactive,InsertedDate) values(@AgentId, @UpdateBy,1,GetDate()) 


END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[Hotel].[Sp_HotelAgentSupplierMappingUpdateHistory] TO [rt_read]
    AS [DB_TEST];

