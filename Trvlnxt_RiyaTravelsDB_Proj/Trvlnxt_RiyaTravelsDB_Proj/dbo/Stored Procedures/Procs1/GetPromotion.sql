CREATE PROC GetPromotion
AS
BEGIN

	SELECT UserType,Supplier,s.SupplierName,PromotionName,TravelValidityFrom,TravelValidityTo,
			BookingValidityFrom,BookingValidityTo,Amount,Percentage--,p.IsSupplier
	FROM B2B_Promotion p
	JOIN B2BHotelSupplierMaster s ON s.Id=p.Supplier
	WHERE p.IsActive=1 and p.IsSupplier=1

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPromotion] TO [rt_read]
    AS [dbo];

