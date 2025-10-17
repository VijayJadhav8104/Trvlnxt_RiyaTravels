-- =============================================
-- Author:		<Ketan Hiranandani>
-- Create date: <11-Aug-2020>
-- Description:	<Get Promotion Details>
-- =============================================
CREATE PROCEDURE GetPromotions	
AS
BEGIN	
		
	SELECT DISTINCT MarketPoint,UserType,dbo.ConcatenateSupplier(dbo.ConcatenateSupplierId(PromotionName)) Supplier,PromotionName,
	dbo.ConcatenateSupplierId(PromotionName) SupplierId,
	CONVERT(VARCHAR(10),TravelValidityFrom,105) + ' - ' +  CONVERT(VARCHAR(10),TravelValidityTo,105)TravelValidity,
	CONVERT(VARCHAR(10),BookingValidityFrom,105) + ' - ' +  CONVERT(VARCHAR(10),BookingValidityTo,105)BookingValidity,
	REPLACE(CONVERT(VARCHAR(11),TravelValidityFrom,113),' ','-') TravelValidityFrom,	
	REPLACE(CONVERT(VARCHAR(11),TravelValidityTo,113),' ','-') TravelValidityTo,
	REPLACE(CONVERT(VARCHAR(11),BookingValidityFrom,113),' ','-') BookingValidityFrom, 
	REPLACE(CONVERT(VARCHAR(11),BookingValidityTo,113),' ','-') BookingValidityTo,
	CASE ActionStatus WHEN 1 THEN 'Active' WHEN 0 THEN 'De-Active' END AS [STATUS],
	Amount,Percentage,GroupType,IsActive,InsertedBy,ActionStatus FROM B2B_Promotion
	WHERE IsActive=1 --AND IsSupplier=1

END


--delete from B2B_Promotion	 where id in (34)	
--update B2B_Promotion set IsActive=1 where id IN (1,2,3,4)


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPromotions] TO [rt_read]
    AS [dbo];

