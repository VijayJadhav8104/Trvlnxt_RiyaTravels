  
-- =============================================  
-- Author:  Akash Singh  
-- Create date: 07-07-2025  
-- Description: Insert Rate and Room Info which need to block   
-- Exec :   
-- =============================================  
CREATE PROCEDURE Hotel.Insert_Sold_Out_RateInfo  
 -- Add the parameters for the stored procedure here  
 @hotelId varchar(300) ='',  
 @rocombo varchar(300) ='',  
 @rname varchar(300) ='',  
 @cin date=null,  
 @cout date=null,  
 @sname varchar(300) ='',  
 @meal varchar(300) ='',  
 @refundable bit ,  
 @price decimal(18,2)=0,
 @CorrelationId varchar(300)=null
   
AS  
 BEGIN  
    
           insert   
           into AllAppLogs.hotel.tbl_API_SoldOut_Room_Blocking  
           (HotelId,RoomOccCombo,RoomName,CheckIN,CheckOut,SupplierName,Meal,Refundable,Price,InsertDate,CorrelationId)  
           values
		   (@hotelId,@rocombo,@rname,@cin,@cout,@sname,@meal,@refundable,@price,GETDATE(),@CorrelationId)  
  
   
 END  