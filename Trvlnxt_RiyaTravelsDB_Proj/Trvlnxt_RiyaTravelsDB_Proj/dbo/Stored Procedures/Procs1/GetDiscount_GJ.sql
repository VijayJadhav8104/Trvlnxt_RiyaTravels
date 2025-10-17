

/****** Object:  StoredProcedure [dbo].[GetDiscount]    Script Date: 7/15/2017 2:42:26 PM ******/

 -- EXEC GetDiscount_GJ '08-AUg-2017','10-Aug-2017','bom','del'

 -- SELECT Code FROM sectors S WHERE S.Code IN('DEL','dxb')@ToSector) AND S.Code IN(@FromSector))

CREATE PROCEDURE [dbo].[GetDiscount_GJ] --'11/1/2017 12:00:00','11/1/2018 12:00:00','DEL','CCU'
 @TravelDateFrom	 DATE,
 @TravelDateTo	     DATE,
 @FromSector		varchar(6),
 @ToSector		    varchar(6)

AS 
BEGIN

	DECLARE @SotoSector bit

	IF exists (SELECT Count(Code) FROM sectors S WHERE S.Code in ( @FromSector))
	   
		BEGIN		
			SET @SotoSector = 0;	
		END
	ELSE
		BEGIN		
			SET @SotoSector = 1;		
		END

	DECLARE @SectorType varchar(2)

	IF ((SELECT Count(Code) FROM sectors S WHERE S.Code in (@ToSector, @FromSector)) > 1 )
	   
		BEGIN		
			SET @SectorType = 'D';	
		END
	ELSE
		BEGIN		
			SET @SectorType = 'I';		
		END

		--select @SectorType

  Select @TravelDateFrom '@TravelDateFrom', @TravelDateTo '@TravelDateTo'	,
      @FromSector '@FromSector' , @ToSector '@ToSector' --Return



   SELECT   AirCode      ,FareType      ,Iata_Percent      ,IsIATAOnBasic      ,Econ_PLB
           ,Prem_PLB      ,Busn_PLB      ,First_PLB      ,IsPLBOnBasic      ,Rbd_exc_PLB
           ,CASE WHEN Soto_exc_PLB = 1 THEN @SotoSector
		          ELSE Soto_exc_PLB 
				  END AS Soto_exc_PLB,
		     CASE WHEN Soto_exc_IATA = 1 THEN @SotoSector
		          ELSE Soto_exc_IATA 
				  END AS Soto_exc_IATA
		   ,Sector_exc_PLB , Rbd_exc_IATA
           ,Soto_exc_IATA , Sector_exc_IATA
		   ,CommissionType

	FROM DiscountMaster 

	WHERE    
	         salesFrm_date <=  GETDATE() --'2017-07-14' 
			 OR
	         salesTo_date  >= GETDATE() --'2017-07-14'
	 OR  ( GETDATE() between salesFrm_date and salesTo_date )
	  OR  ( travelFrm_date <= @TravelDateFrom  OR travelTo_date >= @TravelDateTo )
	  OR  ( travelFrm_date <= @TravelDateFrom AND travelTo_date >= @TravelDateTo )
	
	--(salesTo_date >= GETDATE() OR salesTo_date IS NULL)
	-- AND ((travelTo_date >= @TravelDateFrom OR travelFrm_date IS NULL)) 
	-- AND (travelFrm_date >= @TravelDateFrom OR travelFrm_date IS NULL))
	 AND  FareType = @SectorType 
	 AND  isActive = 'A'


 -- Select * from DiscountMaster

	
	SELECT AirCode AS AirlineCode, amount, ServiceChargeType FROM ServiceCharges 
	WHERE IsActive = 1 AND SectorType = @SectorType

	SELECT AirCode  AS AirlineCode, amount, FlatDiscountType FROM FlatDiscount 
	WHERE IsActive = 1 AND SectorType = @SectorType

	SELECT AirCode , amount, CancellationChargeType FROM CancellationCharges 
	WHERE status = 'A' 

	SELECT taxPercent FROM Taxdetails 
	WHERE Status = 'A' 

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetDiscount_GJ] TO [rt_read]
    AS [dbo];

