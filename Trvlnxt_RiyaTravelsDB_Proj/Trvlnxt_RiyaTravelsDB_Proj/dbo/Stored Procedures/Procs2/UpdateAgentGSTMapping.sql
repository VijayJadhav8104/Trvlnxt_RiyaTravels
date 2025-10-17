CREATE PROC UpdateAgentGSTMapping
	@ICUST VARCHAR(MAX)
	,@Address VARCHAR(MAX)
	,@NameAsOnPAN VARCHAR(MAX)
	,@GSTNo VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	--INSERT INTO mAgentGSTMapping
	--(AgentID,DisplayText,RegistrationNumber,CompanyName,CompanyAddress,State,Email,CreatedOn,IsEditable,CreatedBy)
	--SELECT TOP 1 FKUserID,@NameAsOnPAN,@GSTNo,@NameAsOnPAN,@Address,StateID,AddrEmail,GETDATE(),1,830
	--FROM B2BRegistration Where Icast=@ICUST

	DECLARE @FKUserID INT
	SELECT TOP 1 @FKUserID=FKUserID
	FROM B2BRegistration Where Icast=@ICUST

	INSERT INTO mAgentAttributeMapping
	(AgenId,AttributeId,IsMandate)
	Select @FKUserID,AttributeId,1 
	from mAgentAttributeMapping Where AgenId='47208' AND AttributeId NOT IN (6,39)

	--UPDATE mAgentGSTMapping SET ContactNo=@NameAsOnPAN,Email=@GSTNo
	--WHERE AgentID=@FKUserID
END
