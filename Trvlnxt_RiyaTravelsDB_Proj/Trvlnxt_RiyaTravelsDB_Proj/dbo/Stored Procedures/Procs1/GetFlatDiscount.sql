

  --EXEC GetDiscount '23-AUG-2017','23-AUG-2017','LON','BOM'

	--SELECT Code FROM sectors S WHERE S.Code IN('DEL','dxb')@ToSector) AND S.Code IN(@FromSector))

CREATE PROCEDURE [dbo].[GetFlatDiscount] --'11/1/2017 12:00:00','11/1/2018 12:00:00','DEL','CCU'
@TravelDateFrom	 DATE,
@TravelDateTo	 DATE
AS BEGIN


	SELECT AirCode  AS AirlineCode, amount, FlatDiscountType,minFlatAmt,maxFlatAmt  FROM FlatDiscount 
	WHERE IsActive = 1 AND SectorType = 'D'  and
	 ((salesFrm_date <=  GETDATE() OR salesFrm_date IS NULL) AND (salesTo_date  >= GETDATE() OR salesTo_date IS NULL))
	 AND  ((travelFrm_date <= CONVERT(DATE, @TravelDateFrom) OR travelFrm_date IS NULL ) AND ( travelTo_date >= CONVERT(DATE,@TravelDateTo) OR travelTo_date IS NULL))
	 order by AirCode

	 
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetFlatDiscount] TO [rt_read]
    AS [dbo];

