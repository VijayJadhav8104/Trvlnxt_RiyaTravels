-- Created Date :  27-11-2023                              
-- Created By :  Ketan Hiranandani                             
-- Details :   To Get Manual Booking details by booking id                             
--============================================                              
CREATE PROC [Hotel].GetManualHotelBookingDetailsByID_2                       
 @BookingID VARCHAR(50)=''                             
AS                              
BEGIN                           
   DECLARE @PkId BIGINT;                        
   DECLARE @roomid VARCHAR(MAX);                      
   SET @PkId=(SELECT pkid FROM Hotel_BookMaster WHERE BookingReference=@BookingID);                       
   WITH temp AS ((select  Room_Id AS Service from Hotel_Room_master sr WHERE book_fk_id=@PkId))                      
   --SELECT  @roomid = COALESCE(@roomid + ', ', '') + CAST(SERVICE AS varchar(10)) FROM TEMP            
               
   --hotelBooking                     
   SELECT BookingReference,ClientBookingId,CASE WHEN CurrentStatus='vouchered' THEN 'Confirmed' ELSE CurrentStatus END AS CurrentStatus,providerConfirmationNumber,SupplierName,SupplierUsername,                        
   inserteddate,CONVERT(VARCHAR(20), CONVERT(DATETIMEOFFSET, CheckInDate), 127) AS CheckInDate,              
   CONVERT(VARCHAR(20), CONVERT(DATETIMEOFFSET, CheckOutDate), 127) AS CheckOutDate,              
   PassengerEmail,ConfirmationNumber,SpecialRemark,pkid,hotelid,HotelName,Lat,Lang,HotelPhone,                        
   HotelAddress1,HotelAddress2,cityName,CountryName,ChainName,HotelRating, CheckInTime,CheckOutTime,                      
   STUFF ((SELECT ',' + t2.Salutation + ' ' + t2.FirstName + ' ' + t2.LastName FROM Hotel_Pax_master AS t2 WHERE t2.room_fk_id                       
   IN (SELECT Service FROM temp) FOR XML PATH('')), 1, 1, '' ) AS 'Pax' ,providerConfirmationNumber,cancellationToken,DestinationCountryCode             
   FROM Hotel_BookMaster WHERE BookingReference=@BookingID               
               
   --roomConfirmationDetails                     
   SELECT room_class_id,RateId,bm.providerConfirmationNumber,hst.Id,CASE WHEN hst.Id=4 THEN 'Confirmed' ELSE hst.Status END AS Status                        
   FROM Hotel_Room_master hrm JOIN Hotel_BookMaster bm on bm.pkId=hrm.book_fk_id                        
   LEFT JOIN Hotel_Status_History hsm ON hsm.FKHotelBookingId=hrm.book_fk_id                        
   JOIN Hotel_Status_Master hst ON hst.id=hsm.FkStatusId                        
   WHERE book_fk_id=@PkId and hsm.MethodName='UpdateSucessBookingResponse'                 
                 
   --cancellation policy                        
   SELECT CASE hbm.Refundable WHEN 1 Then 'true' WHEN 0 THEN 'false' end as Refundable,                        
   hbm.CurrencyCode,hcp.RefundText,hcp.Text,hcp.CPStardDate,hcp.CPEndDate, CPEstimatedValue,hbm.section_unique_id AS RecommendationId                        
   FROM Hotel_BookMaster hbm JOIN [Hotel].HotelCancelBookPolicies hcp ON hbm.pkId=hcp.FKBookingId                         
   WHERE pkId=@PkId and hcp.GroupName='Cancellation Policy'                        
              
   --rooms                     
   SELECT Room_Id,room_class_id,RateId,RoomTypeDescription,numOfAdults,numOfChildren FROM Hotel_Room_master WHERE book_fk_id=@PkId                       
              
   --Roomallocation                      
   SELECT hrm.room_class_id,hrm.RateId,hpm.PassengerType,hpm.Salutation,hpm.FirstName,hpm.LastName,hpm.Age,hpm.Email,                      
   hpm.Pancard,hpm.PassportNum,hpm.Contact,hpm.room_fk_id                       
   FROM Hotel_BookMaster hbm JOIN Hotel_Pax_master hpm ON hbm.pkId=hpm.book_fk_id                      
   JOIN Hotel_Room_master hrm ON hrm.Room_Id=hpm.room_fk_id                      
   WHERE pkid=@PkId                         
              
   --Rates RateInfo                 
   SELECT hm.TotalCharges,hm.HotelTotalGross,hm.HotelTaxes,(hm.HotelTotalGross-hm.HotelTaxes) AS amount,                    
   CASE hm.IsGSTRequired WHEN 1 THEN 'true' ELSE 'false' END AS IsGSTRequired,hm.CurrencyCode,                  
SupplierName,SupplierUsername,CASE hm.Refundable WHEN 1 Then 'true' WHEN 0 THEN 'false' END AS Refundable,                 
   CASE hm.PayAtHotel WHEN 1 Then 'true' WHEN 0 THEN 'false' END AS PayAtHotel,                  
   CASE hm.IsPANCardRequired WHEN 1 THEN 'true' WHEN 0 THEN 'false' END AS IsPANCardRequired,            
   CASE hm.Refundable WHEN 1 THEN 'Refundable' WHEN 0 THEN 'NonRefundable' END AS refundability,Meal, HotelIncludes,        
   (SELECT TOP 1 RateId FROM Hotel_Room_master WHERE book_fk_id=@PkId ORDER BY inserteddate DESC) AS RateId          
   FROM hotel_bookmaster hm WHERE pkid=@PkId                     
              
   --Rates Tax                     
   SELECT amount,Discription FROM hotel.Hotel_BookingTax WHERE FKBookId =@PkId                   
              
   --Rates Commission                  
   SELECT hc.RiyaCommission,hb.SCommissionDiscription FROM Hotel_BookMaster hb JOIN B2BHotel_Commission hc ON hb.pkId=hc.Fk_BookId WHERE hb.pkId=@PkId                  
            
   SELECT Amount, taxIncluded,CONVERT(DATETIMEOFFSET, [Date], 127) AS dDate,discount,            
   CASE taxIncluded WHEN 1 THEN 'true' WHEN 0 THEN 'false' END AS taxIncluded            
   FROM [Hotel].[Hotel_RoomRatesPerNight] WHERE FkBookingId=@PkId            
                                         
End                      
                      
--Exec [Hotel].GetManualHotelBookingDetailsByID 'TNHAPI00004896'                              
--select * from Hotel_BookMaster where BookingReference ='TNHAPI00007254'-- like '%TNHAPI%'                      
--select * from [Hotel].HotelCancelBookPolicies where FKBookingId=24559                    
--select * from Hotel_Pax_master where book_fk_id=24559                    
--select * from Hotel_BookMaster where BookingReference like '%TNHAPI%'and TotalRooms=1  ORDER BY inserteddate desc