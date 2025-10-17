CREATE Procedure Proc_InsertSupplierHotelRoomDailyRate      
@Amount float(20)=0,        
@DailyRatesDate datetime,        
@TaxIncluded varchar(200)=null,        
@Discount float(20)=0,        
@FkBookingId int,        
@Room_No int=0 ,      
@RoomId varchar(200)=null,      
@Roomfkid int      
      
As        
Begin        
 Insert into [Hotel].[Hotel_SupplierRoomRatesPerNight](        
 Amount,        
 taxIncluded,        
 [Date],        
 discount,        
 insertDate,        
 FkBookingId,        
 Room_No,      
 RoomId,      
 Roomfkid)        
 values(        
 @Amount,        
 @TaxIncluded,        
 @DailyRatesDate,        
 @Discount,        
 GETDATE(),        
 @FkBookingId,        
 @Room_No,      
 @RoomId,      
 @Roomfkid)        
End 