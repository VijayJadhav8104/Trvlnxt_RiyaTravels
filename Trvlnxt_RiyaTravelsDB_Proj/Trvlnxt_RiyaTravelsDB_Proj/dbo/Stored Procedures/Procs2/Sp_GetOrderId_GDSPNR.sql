--sp_helptext Sp_GetOrderId_GDSPNR  
  
--exec Sp_GetOrderId_GDSPNR '47ISB2','IGJJNE','NA',3,40025    
CREATE Procedure [dbo].[Sp_GetOrderId_GDSPNR]    
	@RiyaPNR nvarchar(30)=null,    
	@AirlinePNR nvarchar(30)=null,    
	@CRSPNR nvarchar(30)=null,    
	@MainAgentId int =null,    
	@AgentID int=null        
as    
Begin   
	--Added BY JD
    Declare @TillDate DateTime
	SELECT @TillDate = TillDate FROM tblBlockTransaction WHERE AgentId = @AgentID

	if(@MainAgentId=0 and @MainAgentId !='')    
	begin    
		PRINT('IF')
		SELECT DISTINCT
			 t.riyaPNR
			, ISNULL(t.GDSPNR,'NA') AS GDSPNR
			, tbi.airlinePNR    
			, t.orderId     
			, t.Country    
			--, ISNULL(T.AgentCurrency,c.CurrencyCode) AS  CurrencyCode  
			,CASE WHEN t.AgentROE <> 1 THEN MC.Value
				ELSE ISNULL(T.AgentCurrency,c.CurrencyCode)
						END AS CurrencyCode	
			, t.frmSector +'/'+t.toSector as Sector
			, t.IssueDate as inserteddate
			, CAST(al.ParentAgentID as nvarchar(30)) ParentAgentID
			, al.UserTypeID
		from tblBookMaster t    
		LEFT JOIN tblBookItenary tbi ON tbi.orderid=t.orderid    
		LEFT JOIN [AirlineCode_Console] ac ON ac.AirlineCode=t.airCode    
		INNER JOIN mCountryCurrency c ON c.CountryCode=t.Country
		LEFT JOIN agentLogin al ON cast(al.UserID as nvarchar(30))=cast(t.AgentID as nvarchar(30))
		LEFT JOIN mcommon MC WITH(NOLOCK) ON al.NewCurrency = MC.ID  
		where t.AgentID!='B2C'  
		AND t.AgentID=@AgentID  
		AND (t.riyaPNR=@RiyaPNR or tbi.airlinePNR= @AirlinePNR or t.GDSPNR=@CRSPNR) 
		AND t.returnFlag=0--and t.BookingStatus!=11 
		AND (@TillDate IS NULL OR (CONVERT(DATE,t.inserteddate) >= (CONVERT(DATE,@TillDate)))) --Added By JD
		order by inserteddate  asc
	END    
	ELSE    
	BEGIN
		PRINT('ELSE')
		select distinct    
			t.riyaPNR
			, ISNULL(t.GDSPNR,'NA') AS GDSPNR
			, tbi.airlinePNR    
			, t.orderId     
			, t.Country
			, CAST(al.ParentAgentID as NVarchar(30)) ParentAgentID
			--, isnull(T.AgentCurrency,c.CurrencyCode) AS  CurrencyCode  
			,CASE WHEN t.AgentROE <> 1 THEN MC.Value
				ELSE ISNULL(T.AgentCurrency,c.CurrencyCode)
						END AS CurrencyCode	
			, t.frmSector +'/'+t.toSector as Sector
			, t.IssueDate as inserteddate
			, al.UserTypeID
			, t.BookingSource
			, t.AgentID
			, ac.type
		from tblBookMaster t    
		LEFT JOIN tblBookItenary tbi ON tbi.orderid=t.orderid    
		LEFT JOIN [AirlineCode_Console] ac ON ac.AirlineCode=t.airCode    
		INNER join mCountryCurrency c ON c.CountryCode=t.Country    
		LEFT JOIN agentLogin al ON cast(al.UserID as nvarchar(30))=cast(t.AgentID as nvarchar(30))
				LEFT JOIN mcommon MC WITH(NOLOCK) ON al.NewCurrency = MC.ID  
		where ((t.Country in (select countrycode from mUserCountryMapping m inner join mcountry C ON C.ID=M.CountryId  WHERE M.isActive=1)))
		AND  (t.riyaPNR=@RiyaPNR or tbi.airlinePNR= @AirlinePNR or t.GDSPNR=@CRSPNR) 
		AND t.returnFlag = 0 --and t.BookingStatus!=11    
		AND (@TillDate IS NULL OR (CONVERT(DATE,t.inserteddate) >= (CONVERT(DATE,@TillDate)))) --Added By JD
		order by inserteddate asc    
	end 
    
    
End    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetOrderId_GDSPNR] TO [rt_read]
    AS [dbo];

