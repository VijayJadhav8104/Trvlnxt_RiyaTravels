  
-- =============================================  
-- Author:  Akash Singh  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- Hotel.Get_BlockedRoom_Details '39658391','1R-2A-1C','2025-08-16','2025-08-21'  
  
-- =============================================  
CREATE PROCEDURE Hotel.Get_BlockedRoom_Details  
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
   RoomName  AS 'rname'  ,  
   CheckIN  AS 'cin'  ,  
   CheckOut  AS 'cout'  ,  
   SupplierName  AS 'sname'  ,  
   Meal          AS 'meal'  ,  
   Refundable    AS 'refund'  ,  
   Price         AS 'price'  ,  
   InsertDate    AS 'insertdate'  
  FROM [AllAppLogs].[Hotel].tbl_API_SoldOut_Room_Blocking  
  WHERE   
 HotelId = @hotelId  
 AND RoomOccCombo= @ROCombo  
 AND CheckIN=cast( @Checkin as date)  
 AND CheckOut= Cast(@CheckOut as date)  
 AND DATEADD(HOUR,6,InsertDate) > GetDATE()   
   
END  



