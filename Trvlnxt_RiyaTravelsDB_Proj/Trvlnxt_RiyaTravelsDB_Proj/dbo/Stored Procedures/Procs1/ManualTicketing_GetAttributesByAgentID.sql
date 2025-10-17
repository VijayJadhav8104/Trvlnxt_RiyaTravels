CREATE PROCEDURE ManualTicketing_GetAttributesByAgentID
	@AgentID Int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT AttributeId
	, IsMandate
	, (CASE 
		WHEN AttributeType = 0 THEN 'Single' -- Without select Main Semen/NonSemen Checkbox value is 0 meanse hide tab
		WHEN AttributeType = 1 THEN 'Both' -- If Select Main Semen/NonSemen Checkbox Value is 1 it means display in Both
		WHEN AttributeType = 2 THEN 'Seaman' -- If Select Main Semen/NonSemen Checkbox and Select Semen from Dropdown
		WHEN AttributeType = 3 THEN 'NonSeaman' -- If Select Main Semen/NonSemen Checkbox and Select NonSemen from Dropdown
		ELSE 'NA' END) AS AttributeType
	, mAttributes.Attributes AS TitleText
	, mAttributes.Value AS AttributeCode
	FROM mAgentAttributeMapping 
	INNER JOIN mAttributes ON mAttributes.ID = mAgentAttributeMapping.AttributeId
	WHERE AgenId = @AgentID
	ORDER BY mAttributes.AttrSeqOrderBy

END