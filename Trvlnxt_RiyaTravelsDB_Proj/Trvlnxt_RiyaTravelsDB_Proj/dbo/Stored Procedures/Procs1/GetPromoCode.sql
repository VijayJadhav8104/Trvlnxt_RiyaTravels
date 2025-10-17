

CREATE PROCEDURE [dbo].[GetPromoCode] --'11/1/2017 12:00:00','11/1/2018 12:00:00','DEL','CCU'
@TravelDateFrom	 DATE,
@TravelDateTo	 DATE,
@FareType varchar(50),
@PromoCode varchar(50)
AS BEGIN
	
    SELECT [Pk_Id],[AirCode],[FareType],[salesFrm_date],[salesTo_date],[travelFrm_date],[travelTo_date]
      ,[SectorIncludeFrom],[SectorIncludeTo],[SectorExcludeFrom],
	  [SectorExcludeTo],[MinFareAmount],[Discount],[Remark],[UserType],[PromoType]
      ,[IncludeFlat],[PromoCode],[insertDate],[userID],[modifiedDate],[ModifiedBy],[IsActive],GST
	 FROM PromoCode 
	 WHERE ((salesFrm_date <=  GETDATE() OR salesFrm_date IS NULL) AND (salesTo_date  >= GETDATE() OR salesTo_date IS NULL))
	 AND  ((travelFrm_date <= CONVERT(DATE, @TravelDateFrom) OR travelFrm_date IS NULL ) AND ( travelTo_date >= CONVERT(DATE,@TravelDateTo) OR travelTo_date IS NULL))	
	 AND  FareType = @FareType and PromoCode=@PromoCode
	 AND  isActive = 1
	 	
select emailId,U.UserName from  tblBookMaster B
	left JOIN UserLogin U ON U.UserID=B.LoginEmailID
	where promoCode =@PromoCode
	AND IsBooked=1
	
	SELECT taxPercent FROM Taxdetails 
	WHERE Status = 'A'  
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPromoCode] TO [rt_read]
    AS [dbo];

