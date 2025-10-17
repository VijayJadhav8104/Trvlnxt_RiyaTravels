CREATE PROC GetSupplierNameByAgentId
@AgentId INT
AS
BEGIN
	--SELECT SM.SupplierName FROM AgentSupplierProfileMapper ASPM INNER JOIN B2BHotelSupplierMaster SM ON ASPM.SupplierId=SM.Id
	--WHERE ASPM.AgentId=@AgentId AND ASPM.IsActive=1 AND SM.IsActive=1;

	-------changes by Altamash
	SELECT SM.SupplierName 
	FROM AgentSupplierProfileMapper ASPM 
	INNER JOIN B2BHotelSupplierMaster SM ON ASPM.SupplierId=SM.Id
	inner join B2BRegistration BR on ASPM.AgentId=BR.PKID
	WHERE BR.FKUserID=@AgentId
		  AND ASPM.IsActive=1 
		  AND SM.IsActive=1;

	
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetSupplierNameByAgentId] TO [rt_read]
    AS [dbo];

