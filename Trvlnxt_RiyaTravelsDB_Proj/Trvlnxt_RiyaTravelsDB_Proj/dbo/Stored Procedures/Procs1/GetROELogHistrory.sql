--exec [dbo].[GetROELogHistrory] '2022-12-24','2022-01-23','INR','USD'
CREATE PROCEDURE [dbo].[GetROELogHistrory]
	-- Add the parameters for the stored procedure here
	 @StartDate DateTime
	 ,@EndDate DateTime
	 ,@fromCurr varchar(3)
	 ,@toCurr varchar(3)
AS
BEGIN
	--SELECT ROE
	select * from ROE where FromCur=@fromCurr and ToCur=@toCurr and InserDate between @StartDate and @EndDate order by InserDate

	--Select ROELogHistory
	Select * from ROELogHistory where FromCurrency=@fromCurr and ToCurrency=@toCurr order by InsertedDate
END