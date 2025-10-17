 -- exec [B2BHotel_ModifedBooking]   68198                                                  
        
                                                                              
CREATE PROCEDURE [dbo].[B2BHotel_ModifedBooking]                                                                                                                                                       
 -- Add the parameters for the stored procedure here                                                                                                                                                      
                                                                                                                                                       
 @Id int=0                                                                                                                                                      
                                                                                                                                                      
AS                                                                                                                                                      
BEGIN          
        
select         
DISTINCT        
    
  CASE WHEN HD.book_fk_id=HRM.book_fk_id THEN HD.RoomType ELSE HRM.RoomTypeDescription END as RoomType         
,CASE WHEN HD.book_fk_id=HRM.book_fk_id THEN HD.RoomMealBasis ELSE HRM.RoomMealBasis END as Meal               
  ,HB.BookingReference as 'book_Id'    
  ,HB.CurrentStatus
  , HB.Nationalty as Nationality
  ,HB.PassengerPhone                                                                                                           
   ,HB.PassengerEmail
   ,HB.cityName as HotelCity    
   ,HB.HotelBookCountryName as 'HotelCountry'    
   ,HB.CheckInDate as 'CheckInDate'    
   ,HB.CheckOutDate as 'CheckOutDate'    
   ,HB.HotelName    
   ,hb.HotelAddress1 as 'HotelAddress'    
   ,HB.HotelPhone as 'HotelPhoneNo'
   ,HP.RoomNo
    ,HP.id as 'PaxId'
	 ,HP.IsLeadPax  
	,HP.MealBasis  
   , hp.room_fk_id as RoomId
   ,HRM.RoomDiscription as RoomInclusion
   ,isnull(HP.RoomType,HRM.RoomTypeDescription) as 'RType'  
  , CASE WHEN HD.book_fk_id=@ID and HD.book_fk_id=HP.book_fk_id  THEN (HD.TITLE+' '+ HD.FName + ' ' + HD.LName+ ' ' + case hp.PassengerType when 'Child' then '('+ hp.age + ' Yrs)' else ''end) ELSE      
  (HP.Salutation+' '+ HP.FirstName +' '+ HP.LastName+ ' ' +case PassengerType when 'Child' then '('+age+' Yrs)' else ''end) END  as PassengerName,    
      
   CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.TITLE ELSE HP.Salutation END as 'title'                                                                                                           
   ,CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.FName ELSE HP.FirstName END as 'fname'                 
   ,CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.LName ELSE HP.LastName END as 'Lname'       
  from Hotel_BookMaster HB    
  left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId and SH.IsActive=1    
  left join mUser MU on HB.MainAgentID=MU.ID     
    left join Hotel_Room_master HRM on HB.pkId=HRM.book_fk_id                                                                                                                                                  
  INNER join Hotel_Pax_master HP on HRM.Room_Id=HP.room_fk_id                                                                                  
  LEFT join tblAgentBalance TBL on HB.orderId = TBL.BookingRef                                                                                                  
  LEFT JOIN Hotel.HotelBookingModifyDetails HD ON HB.pkId= HD.book_fk_id and HRM.Room_Id=HD.room_fk_id and HP.ID=HD.pax_fk_id AND HD.IsActive=1                                        
                                                                                                                                  
   where                                                                                                                                                       
  (HB.pkId = @Id)                                                                                                                            
   and SH.IsActive=1                                                           
                        
END