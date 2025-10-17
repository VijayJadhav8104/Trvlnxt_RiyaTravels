
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Hotel].[Get_BlockedRoom_Details]
	-- Add the parameters for the stored procedure here

	@hotelId varchar(300)='',
	@ROCombo varchar(300)='',
	@Checkin date,
	@CheckOut date
	
AS
BEGIN

  SELECT 
	  HotelId       AS 'hids'  ,
	  RoomOccCombo  AS 'rocombo'  ,
	  RoomName		AS 'rname'  ,
	  CheckIN		AS 'cin'  ,
	  CheckOut		AS 'cout'  ,
	  SupplierName  AS 'sname'  ,
	  Meal          AS 'meal'  ,
	  Refundable    AS 'refund'  ,
	  Price         AS 'price'  ,
	  InsertDate    AS 'insertdate'
  FROM hotel.tbl_API_SoldOut_Room_Blocking
  WHERE 
	HotelId = @hotelId
	AND RoomOccCombo= @ROCombo
	AND CheckIN=@Checkin
	AND CheckOut = @CheckOut
	AND DATEADD(HOUR,6,InsertDate) > GetDATE()	
 
END
