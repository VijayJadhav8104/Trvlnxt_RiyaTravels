--EXEC [dbo].[FetchCurrentUserBalanceByUserID] null,null,3
CREATE PROCEDURE [dbo].[FetchCurrentUserBalanceByUserID]   
@FromDate date=null,
@ToDate date=null,
@UserID int,
@Country varchar(10)
AS
BEGIN  
	IF(@FromDate IS NULL OR @ToDate IS NULL)
	BEGIN
		SELECT TOP 10
		t.CreatedOn
		,cou.Currency+' '+CONVERT(Varchar(100),CONVERT(Decimal(18,2), t.Amount)) AS Amount
		,t.TransactionType
		,(select top 1 tsb.CloseBalance from tblSelfBalance as tsb where tsb.UserId = T.UserId order by tsb.CreatedOn desc) as ClosingBalance
		,t.Remark
		,usr.UserName+' - '+usr.FullName AS AssignedBy
		FROM mSelfBalanceCreditDebit T  
		--left join tblSelfBalance on tblSelfBalance.UserId = T.UserID
		INNER JOIN mCountry as cou on t.CountryId=cou.ID
		LEFT JOIN mUser as usr on t.CreatedBy=usr.ID
		WHERE 
		--CONVERT(DATE,t.CreatedOn)>=convert(DATE,@FromDate) and CONVERT(DATE,t.CreatedOn)<=convert(DATE,@ToDate)
		t.UserId = @UserID
		AND (@Country='' or cou.CountryCode=@Country)
		AND t.Remark IS NOT NULL
		ORDER BY CreatedOn DESC
	END
	ELSE
	BEGIN
		SELECT
		t.CreatedOn
		,cou.Currency+' '+CONVERT(Varchar(100),CONVERT(Decimal(18,2), T.Amount)) AS Amount
		,t.TransactionType
		,(select top 1 tsb.CloseBalance from tblSelfBalance as tsb where tsb.UserId = T.UserId order by tsb.CreatedOn desc) as ClosingBalance
		,t.Remark
		,usr.UserName+' - '+usr.FullName AS AssignedBy
		FROM mSelfBalanceCreditDebit T  
		INNER JOIN mCountry as cou on T.CountryId=cou.ID
		LEFT JOIN mUser as usr on t.CreatedBy=usr.ID
		WHERE CONVERT(DATE,t.CreatedOn)>=convert(DATE,@FromDate) and CONVERT(DATE,t.CreatedOn)<=convert(DATE,@ToDate)
		AND (@Country='' or cou.CountryCode=@Country)
		AND t.UserId = @UserID
		AND Remark IS NOT NULL
		ORDER BY CreatedOn DESC
	END
END