

  --EXEC GetDiscount '23-AUG-2017','23-AUG-2017','LON','BOM'

	--SELECT Code FROM sectors S WHERE S.Code IN('DEL','dxb')@ToSector) AND S.Code IN(@FromSector))

CREATE PROCEDURE [dbo].[GetDiscount] --'11/1/2017 12:00:00','11/1/2018 12:00:00','DEL','CCU'
@TravelDateFrom	 DATE,
@TravelDateTo	 DATE,
@FromSector		varchar(6),
@ToSector		varchar(6)
AS BEGIN
	DECLARE @SotoSector bit
	IF ((SELECT Count(Code) FROM sectors S WHERE S.Code in (@ToSector, @FromSector)) >0  )
	--IF exists (SELECT Count(Code) FROM sectors S WHERE S.Code in ( @FromSector))	   
		BEGIN		
			SET @SotoSector = 0;	
		END
	ELSE
		BEGIN		
			SET @SotoSector = 1;		
		END
		--SELECT @SotoSector
	DECLARE @SectorType varchar(2)
	IF ((SELECT Count(Code) FROM sectors S WHERE S.Code in (@ToSector, @FromSector)) > 1 )	   
		BEGIN		
			SET @SectorType = 'D';	
		END
	ELSE
		BEGIN		
			SET @SectorType = 'I';		
		END  --select @SectorType

    SELECT AirCode, FareType, Iata_Percent, IsIATAOnBasic, Econ_PLB, Prem_PLB, Busn_PLB, First_PLB, IsPLBOnBasic, Rbd_exc_PLB
     ,CASE WHEN Soto_exc_PLB = 1 THEN @SotoSector ELSE Soto_exc_PLB  END AS Soto_exc_PLB
	 ,CASE WHEN Soto_exc_IATA = 1 THEN @SotoSector ELSE Soto_exc_IATA END AS Soto_exc_IATA
	 ,Sector_exc_PLB , Rbd_exc_IATA, Soto_exc_IATA, Sector_exc_IATA, CommissionType
	 FROM DiscountMaster 
	 WHERE ((salesFrm_date <=  GETDATE() OR salesFrm_date IS NULL) AND (salesTo_date  >= GETDATE() OR salesTo_date IS NULL))
	 AND  ((travelFrm_date <= CONVERT(DATE, @TravelDateFrom) OR travelFrm_date IS NULL ) AND ( travelTo_date >= CONVERT(DATE,@TravelDateTo) OR travelTo_date IS NULL))	
	 AND  FareType = @SectorType 
	 AND  isActive = 'A'

	
	SELECT AirCode AS AirlineCode, amount, ServiceChargeType FROM ServiceCharges 
	WHERE IsActive = 1 AND SectorType = @SectorType

	SELECT AirCode  AS AirlineCode, amount, FlatDiscountType,minFlatAmt,maxFlatAmt  FROM FlatDiscount 
	WHERE IsActive = 1 AND SectorType = @SectorType  and
	 ((salesFrm_date <=  CONVERT(DATE,GETDATE()) OR salesFrm_date IS NULL) AND (salesTo_date  >= CONVERT(DATE,GETDATE()) OR salesTo_date IS NULL))
	 AND  ((travelFrm_date <= CONVERT(DATE, @TravelDateFrom) OR travelFrm_date IS NULL ) AND ( travelTo_date >= CONVERT(DATE,@TravelDateTo) OR travelTo_date IS NULL))
	 order by AirCode

	SELECT AirCode , amount, CancellationChargeType FROM CancellationCharges 
	WHERE status = 'A' 

	SELECT taxPercent FROM Taxdetails 
	WHERE Status = 'A' 

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetDiscount] TO [rt_read]
    AS [dbo];

