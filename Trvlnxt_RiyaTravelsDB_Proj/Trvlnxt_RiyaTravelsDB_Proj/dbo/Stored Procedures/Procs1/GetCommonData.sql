-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 09 March 2020
-- Description:	To Get the common Data for DropDown
-- =============================================
--exec [dbo].[GetCommonData] '',18,'US','RBT'
CREATE PROCEDURE [dbo].[GetCommonData] 
	-- Add the parameters for the stored procedure here
	@Option varchar(30),
	@Id varchar(30),
	@MarketPoint VARCHAR(30)=null,
	@UserType VARCHAR(10)=null
AS
BEGIN
	if(@Option='CRS')
	begin
		SELECT CategoryValue,pkid from tbl_commonmaster where Category=@Option
	end
	else if(@Option='CARD')
	begin
		SELECT BankName 
		+ '[************' + substring(CardNumber,len(CardNumber)-3,len(CardNumber)) + ']  [' + CardType + ']' as Text,cm.pkid as value 
		from tblCardMaster cm
		inner JOIN mUser U on U.ID=cm.InsertedBy
		WHERE Status=1 and MarketPoint=@MarketPoint and UserType=@UserType;
	end
	else if(@Option='CARDDetails')    
	begin    
		SELECT BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text,cm.pkid as value     
		from mCardDetails cm    
		inner JOIN mUser U on U.ID=cm.InsertedBy    
		WHERE Status=1 and MarketPoint=@MarketPoint and UserType=@UserType;    
	end    
	else if(@Option='CARDDetails')    
	begin    
		SELECT BankName + '[************' + substring(CardNumber,len(CardNumber)-3,len(CardNumber)) + ']  [' + CardType + ']' as Text,cm.pkid as value     
		from mCardDetails cm    
		inner JOIN mUser U on U.ID=cm.InsertedBy    
		WHERE Status=1 and MarketPoint=@MarketPoint and UserType=@UserType;    
	end    
	else if(@Option='officeid')
	begin
		SELECT DISTINCT C.CategoryValue AS OfficeID,OC.Currency,c.Country  from tbl_commonmaster C
   		INNER JOIN tblOwnerCurrency OC ON OC.OfficeID=C.CategoryValue  where Category='officeid' and Mapping=@Id
	end
	else if(@Option='' and @Id <>'')
	begin
		--commented by asmita
		--SELECT CategoryValue,pkid  from tbl_commonmaster where Mapping=@Id
		SELECT CategoryValue,pkid
		FROM (
			SELECT DISTINCT CategoryValue,pkid , ROW_NUMBER() OVER(PARTITION BY CategoryValue ORDER BY pkid DESC) rn from tbl_commonmaster where Mapping=@Id
        ) a
		WHERE rn = 1
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCommonData] TO [rt_read]
    AS [dbo];

