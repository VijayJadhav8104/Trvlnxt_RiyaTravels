CREATE Procedure [dbo].[Sp_SSRaddtionBookingHistory]
	@RiyaPnr nvarchar(30)=null
	, @Currency nvarchar(10)=null
AS
BEGIN
	SELECT (CASE WHEN c.CurrencyCode!=@Currency 
					THEN SUM(ISNULL(SSR.SSR_Amount,0)) * (tb.AgentROE * tb.ROE) 
					ELSE SUM(isnull(SSR.SSR_Amount,0)) *(tb.ROE)
			END) AS SSR_Amount  
	FROM tblBookMaster TB WITH(NOLOCK)
	LEFT JOIN tblSSRDetails SSR WITH(NOLOCK) ON tb.pkId=ssr.fkBookMaster
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) ON c.CountryCode=tb.Country
	WHERE riyapnr=@RiyaPnr OR GDSPNR = @RiyaPnr and TB.BookingStatus != 18
	GROUP BY CurrencyCode,tb.AgentROE,tb.roe
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_SSRaddtionBookingHistory] TO [rt_read]
    AS [dbo];

