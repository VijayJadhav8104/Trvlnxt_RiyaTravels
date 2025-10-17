--GetLastThreeMonthsAgentBalance 51366
CREATE PROC GetLastThreeMonthsAgentBalance
	@AgencyID int 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		AgencyName
		, T.CreatedOn
		, TranscationAmount
		, isnull(CloseBalance, 0) AS Total
		, TransactionType
		, AddrLandlineNo
		, Remark
		, Reference
		--avinash added  
		, convert(varchar(20),b.AirlineStartDate,106) AirlineStartDate
		, convert(varchar(20),(b.AirlineStartDate + b.AirlineCreditday),106) EndDate
		, b.AirlineCreditday
		, t.DueClear
		, musr.UserName
		FROM tblAgentBalance as T WITH(NOLOCK)
		INNER JOIN B2BRegistration B WITH(NOLOCK) ON b.FKUserID = t.AgentNo
		LEFT JOIN mUser musr WITH(NOLOCK) ON T.CreatedBy=musr.ID
		WHERE t.AgentNo = @AgencyID
		AND Remark IS NOT NULL
		AND T.CreatedOn>=DATEADD(MONTH,-3, GETDATE()) 
		AND T.CreatedOn<=GETDATE()
		ORDER BY T.CreatedOn DESC
END
