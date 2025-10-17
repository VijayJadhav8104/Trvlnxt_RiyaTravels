CREATE procedure [dbo].[sp_ReissueUploaderDetails] 
	@FromDate Datetime
	, @Todate Datetime
	, @AgentID varchar(50)
	, @AgencyNameList varchar(max) = ''
AS
BEGIN
	SELECT ID
			, TopUpCr
			, [Issue Date]
			, [Customer No]
			, [Ship-to Customer No]
			, [Customer Location Code]
			, [Ticket Type]
			, [Agent ID]
			, [PNR No]
			, [Airline Code]
			, [Ticket No]
			, [Pax Type]
			, [First Name]
			, [Last Name]
			, [Currency Code]
			, [Basic Fare]
			, [Tax YR]
			, [Tax YQ]
			, [Tax IN]
			, [Tax K3]
			, [Tax AF]
			, [Tax P2]
			, [Tax WO]
			, [GB Tax]
			, [CP Tax]
			, [UB Tax]
			, [CMF Tax]
			, [COMM Tax]
			, [COMMBF Tax]
			, [RCS Tax]
			, [RCF Tax]
			, [RF Tax]
			, [Tax XT]
			, [Tax Total]
			, [Tax Q]
			, [Total Fare]
			, [Net Fare]
			, [FOP]
			, [Tour Code/Deal Code]
			, [Purchase Currency]
			, [Sector Name]
			, [Flight No]
			, [Class]
			, [Date Of Travel]
			, [BookingIdentification]
			, [FromCity]
			, [ToCity]
			, [CardType]
			, [IATA Code]
			, [Travel End Date]
			, [Global Dimension 2 Code]
			, [Purch Exchange Rate]
			, [Purchase Currency1]
			, [Created By]
	FROM tblReissueUploaderDetails R WITH(NOLOCK)
	WHERE CONVERT(DATE,R.[Created Date]) BETWEEN @FromDate AND @Todate                                            
	AND ((@AgencyNameList = '') or (R.[Agent ID] IN (SELECT DATA FROM sample_split(@AgencyNameList,','))))                             
	ORDER BY [Created Date] DESC                                      
end 