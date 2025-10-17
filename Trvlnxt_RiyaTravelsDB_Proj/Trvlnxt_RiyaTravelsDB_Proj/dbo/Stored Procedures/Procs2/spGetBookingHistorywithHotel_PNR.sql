  
CREATE PROCEDURE [dbo].[spGetBookingHistorywithHotel_PNR] -- [spGetBookingHistorywithHotel_PNR] '23F8D9',1                          
 @RiyaPNR VARCHAR(500)                        
 ,@opr INT                        
AS                        
--BEGIN                          
-- IF(@opr=1)--Upcoming Trip                          
BEGIN                        
 ---hotel section                          
 SELECT *                        
 INTO #hotelbook                        
 FROM (                        
  SELECT hm.[pkId]                        
   ,searchApiId                        
   ,section_unique_id                        
   ,[book_Id]                        
   ,[AgentId]                        
   ,[book_message]                        
   --,CurrentStatus                        
   ,SM.Status as CurrentStatus                        
   ,[BookingReference]                        
   ,[riyaPNR]                        
   ,CASE                         
    WHEN ConfirmationNumber IS NULL                        
     THEN 'NA'                        
    ELSE ConfirmationNumber                        
    END AS ConfirmationNumber                        
   ,[TotalCharges]                        
   ,[LeaderTitle] + '.' + [LeaderFirstName] + ' ' + [LeaderLastName] AS BookingBy                        
   ,[HotelName]                        
   ,[HotelPhone]                        
   ,[CountryName]                        
   ,[HotelAddress1]                        
   ,[ExpirationDate]                        
   ,AgentRefNo                        
   ,[TotalAdults]                        
   ,[TotalChildren]                        
   ,[TotalRooms]                        
   ,[HotelAddress2]                        
   ,convert(VARCHAR, [CheckInDate], 106) AS [CheckInDate]                        
   ,convert(VARCHAR, [CheckOutDate], 106) AS [CheckOutDate]                        
   ,[AgentRate]                        
   ,isnull(CancelDate, 0) CancelDate                        
   ,[SelectedNights]                        
   ,[PassengerPhone]                        
   ,[PassengerEmail]                        
   ,BR.AddrMobileNo as 'AgentMobile'                        
   ,BR.AddrEmail as 'AgentEmail'                        
   ,ContractComment      
         
   ,CancellationCharge                        
   ,hm.[inserteddate]             
   ,hm.[OBTCNo] as 'OBTCNo'            
   ,[cityName]                        
   ,hm.orderId                        
   ,CASE                         
    WHEN HotelRating IS NULL                        
     OR HotelRating = ''                        
     THEN '0.0'                        
    ELSE HotelRating                        
    END AS HotelRating                        
   ,CASE                         
    WHEN (                        
      (                        
       convert(DATE, DATEADD(hh, - [CancelHours], [CheckInDate])) < [CheckInDate]                        
       AND [ExpirationDate] < [CheckInDate]                        
       AND hm.IsCancelled IS NULL                        
       )                        
      )                        
     THEN 1                        
    WHEN hm.IsCancelled = 1                        
     THEN 0                        
    ELSE 0                        
    END AS alllowCancel                        
   ,[SupplierName]                        
   ,[SupplierPhoneNo]                        
   ,[SupplierReferenceNo]                        
   ,[SupplierCurrencyCode]                        
   ,[SupplierRate]                        
   ,RoomTypeDescription                       
   ,Meal                      
   ,[QtechCancelCharge]                        
   ,[QtechTotalCharges]                        
   ,[QtechAppliedAgentCharges]                        
   ,[QtechAppliedAgentRate]                        
   ,hm.AgentRemark as AgentReference                        
   ,CancellationPolicy              
   ,HotelConfNumber as HotelConfirmationNumber   
   ,ISNULL(SpecialRemark,'') as SpecialRemark  
  FROM [dbo].[Hotel_BookMaster] hm WITH(NOLOCK)                        
  LEFT JOIN Hotel_Room_master rm WITH(NOLOCK) ON hm.pkId = rm.book_fk_id                        
  left join Hotel_Status_History SH WITH(NOLOCK) on SH.FKHotelBookingId=hm.pkId and SH.IsActive=1                        
  left join Hotel_Status_Master SM WITH(NOLOCK) on SM.Id=SH.FkStatusId                        
  left join B2BRegistration BR WITH(NOLOCK) on hm.RiyaAgentID=BR.FKUserID            
                        
  WHERE                       
                    
    riyaPNR = @RiyaPNR                        
                    
  
 and SH.FkStatusId = 4    
               
  ) H                        
                        
 SELECT pax.*                        
  ,pay.amount                        
 FROM #hotelbook pax              
 left JOIN dbo.Paymentmaster pay WITH(NOLOCK) ON pax.orderId = pay.order_id                        
  AND pay.Type = 'Hotel';                        
                        
 SELECT [Salutation]                        
  ,[FirstName]                        
  ,[LastName]                        
  ,[book_fk_id]                        
  ,[orderId]                        
  ,[IsCancelled]                        
  ,[IsBooked]                        
  ,[inserteddate]        
  ,[RoomType]        
  ,[RoomNo]       
  ,[PassengerType]      
                        
 FROM [dbo].[Hotel_Pax_master]  WITH(NOLOCK)                       
 WHERE book_fk_id IN (                   
   SELECT [pkId]                        
   FROM #hotelbook                        
   )                        
                        
 DROP TABLE #hotelbook;                        
  ----                          
END   
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetBookingHistorywithHotel_PNR] TO [rt_read]
    AS [dbo];

