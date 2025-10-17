CREATE FUNCTION  [dbo].[GetRHLedgerValue] (
	@AgentID varchar(50),	
	@OfficeID Varchar(50)
)
RETURNS VARCHAR(50) AS
BEGIN
	
	Declare @RHLedgers VARCHAR(50)='',@userTypeID INT,@BookingCountry VARCHAR(10),@eCountry VARCHAR(10)

	if(@AgentID!='B2C')
	BEGIN
		Select top 1 @userTypeID=userTypeID,@BookingCountry=BookingCountry from agentLogin Where UserID=@AgentID
		Select top 1 @eCountry=ISNULL(Value,'') from mVendorCredential Where OfficeId=@OfficeID AND FieldName='ERP Country'
		IF(@userTypeID=4)
		BEGIN
			IF(@BookingCountry='IN' OR @BookingCountry='US')
			BEGIN
				SET @RHLedgers=(CASE WHEN @eCountry='IN' THEN 'RTTICU'
									WHEN @eCountry = 'US' THEN 'RTTINC'
									WHEN @eCountry = 'CA' THEN 'RTTCAN'
									WHEN @eCountry = 'AE' THEN 'RTTDXB'
									ELSE '' END)
			END
			ELSE 
			BEGIN
				SET @RHLedgers=''
			END
		END
		ELSE
		BEGIN						
			(Select top 1 @RHLedgers=ISNULL(wy.[RH Ledgers],'')
					from tblInterBranchWinyatra wy 			
					INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=@AgentID
					INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId = @OfficeID AND FieldName='ERP Country' AND wy.Country=mc.Value) 
		END
	END
	
    RETURN @RHLedgers
END
