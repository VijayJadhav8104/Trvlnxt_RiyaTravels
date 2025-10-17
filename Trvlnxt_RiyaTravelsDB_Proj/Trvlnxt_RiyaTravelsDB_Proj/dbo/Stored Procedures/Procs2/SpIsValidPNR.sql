CREATE Procedure SpIsValidPNR-- 'OZN7IK' ,21967
@PNRNumber varchar(10),
@AgentID int
AS
BEGIN

	--if exists( SELECT * FROM CrypticCommand WHERE PNRNumber=@PNRNumber AND CreatedBy=@AgentID)
	--begin
	--	SELECT COUNT(*) FROM CrypticCommand WHERE PNRNumber=@PNRNumber AND CreatedBy=@AgentID
	--	
	--end 
	--else
	--begin
		select COUNT(*) from tblBookMaster where GDSPNR=@PNRNumber and AgentID!='B2C' and AgentID=@AgentID 
	--end

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpIsValidPNR] TO [rt_read]
    AS [dbo];

