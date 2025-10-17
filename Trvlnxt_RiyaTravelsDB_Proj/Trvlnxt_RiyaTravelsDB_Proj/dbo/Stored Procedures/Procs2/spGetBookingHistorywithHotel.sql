CREATE PROCEDURE [dbo].[spGetBookingHistorywithHotel]  --'[spGetBookingHistorywithHotel] 'ashvini.gawde@riya.travel',1  
 @EmailID varchar(500),  
 @opr int   
AS  
BEGIN  
 IF(@opr=1)--Upcoming Trip  
 BEGIN  
   
    
  
  
  
   ---hotel section  
    select * into #hotelbook  
  from (  
  SELECT   [pkId]  ,searchApiId     
      ,[book_Id]      ,[AgentId]      ,[book_message]      ,[BookingReference]      ,[riyaPNR]      ,[ConfirmationNumber]  
      ,[TotalCharges]      ,[LeaderTitle]+'.'+[LeaderFirstName]+' '+[LeaderLastName]  as BookingBy      ,[HotelName]      ,[CountryName]       
         ,[HotelAddress1]      ,[CurrentStatus]      ,[ExpirationDate]  
      ,[TotalAdults]      ,[TotalChildren]      ,[TotalRooms]      ,[HotelAddress2]  
           ,[CheckInDate]      ,[CheckOutDate]      ,[AgentRate]        
      ,[SelectedNights]             ,[PassengerPhone]      ,[PassengerEmail]      
      ,[inserteddate]         ,[cityName],orderId,  case when HotelRating is null or HotelRating='' then '0.0' else HotelRating end as  HotelRating  
   ,case when (convert(date,DATEADD(hh,-[CancelHours],[CheckInDate]))<[CheckInDate] and [ExpirationDate]<[CheckInDate]) then 1 else 0 end as alllowCancel  
  FROM [dbo].[Hotel_BookMaster]  WITH(NOLOCK)
  where IsBooked=1 and IsCancelled is null and [PassengerEmail]=@EmailID and Convert(date,CheckInDate)>Convert(date,GETDATE()))H  
    
    
   select pax.*,pay.amount from #hotelbook  
    pax  
  inner join dbo.Paymentmaster pay WITH(NOLOCK) on pax.orderId=pay.order_id  
   and pay.Type='Hotel';  
  
  
  SELECT  [Salutation]  
      ,[FirstName]  
      ,[LastName]  
       
       
      ,[book_fk_id]  
      ,[orderId]  
      ,[IsCancelled]  
      ,[IsBooked]  
      ,[inserteddate]  
        
  FROM [dbo].[Hotel_Pax_master] WITH(NOLOCK) 
  where [IsBooked]=1 and book_fk_id in (select [pkId] from #hotelbook)  
   
  
  drop table #hotelbook;   
  ----  
  
 END  
 else If(@opr=2) --Completed Trip  
 begin  
      
      
     
  
     ---hotel section  
    select * into #hotelbookcomp  
  from (  
  SELECT   [pkId]    ,searchApiId     
      ,[book_Id]      ,[AgentId]      ,[book_message]      ,[BookingReference]      ,[riyaPNR]      ,[ConfirmationNumber]  
      ,[TotalCharges]      ,[LeaderTitle]+'.'+[LeaderFirstName]+' '+[LeaderLastName]  as BookingBy    
      ,[LeaderLastName]        ,[HotelName]      ,[CountryName]       
         ,[HotelAddress1]      ,[CurrentStatus]      ,[ExpirationDate]  
      ,[TotalAdults]      ,[TotalChildren]      ,[TotalRooms]      ,[HotelAddress2]  
           ,[CheckInDate]      ,[CheckOutDate]      ,[AgentRate]        
      ,[SelectedNights]             ,[PassengerPhone]      ,[PassengerEmail]      
      ,[inserteddate]         ,[cityName],orderId, case when HotelRating is null or HotelRating='' then '0.0' else HotelRating end as  HotelRating  
  ,0 as alllowCancel  
  FROM [dbo].[Hotel_BookMaster] WITH(NOLOCK) 
  where IsBooked=1 and [PassengerEmail]=@EmailID and IsCancelled is null  and Convert(date,CheckInDate)<Convert(date,GETDATE()))H  
    
    
    
 select pax.*,pay.amount from #hotelbookcomp  
    pax  
  inner join dbo.Paymentmaster pay on pax.orderId=pay.order_id  
   and pay.Type='Hotel';  
  
  SELECT  [Salutation]  
      ,[FirstName]  
      ,[LastName]  
          ,[book_fk_id]  
      ,[orderId]  
      ,[IsCancelled]  
      ,[IsBooked]  
      ,[inserteddate]  
   
  FROM [dbo].[Hotel_Pax_master] pax WITH(NOLOCK) 
    
  where [IsBooked]=1 and book_fk_id in (select [pkId] from #hotelbookcomp)  
    
  
  drop table #hotelbookcomp;   
  -------hotel end  
  
  
 end  
 else if(@opr=3)  -- Canceled Trip  
 begin  
     
    
     
  
  
   ---hotel section  
    select * into #hotelbookcanc  
  from (  
  SELECT   [pkId]   ,searchApiId      
      ,[book_Id]      ,[AgentId]      ,[book_message]      ,[BookingReference]      ,[riyaPNR]      ,[ConfirmationNumber]  
      ,[TotalCharges]      ,[LeaderTitle]+'.'+[LeaderFirstName]+' '+[LeaderLastName]  as BookingBy    
      ,[LeaderLastName]        ,[HotelName]      ,[CountryName]       
         ,[HotelAddress1]      ,[CurrentStatus]      ,[ExpirationDate]  
      ,[TotalAdults]      ,[TotalChildren]      ,[TotalRooms]      ,[HotelAddress2]  
           ,[CheckInDate]      ,[CheckOutDate]      ,[AgentRate]        
      ,[SelectedNights]             ,[PassengerPhone]      ,[PassengerEmail]      
      ,[inserteddate]         ,[cityName],orderId, case when HotelRating is null or HotelRating='' then '0.0' else HotelRating end as  HotelRating  
  ,0 as alllowCancel  
  FROM [dbo].[Hotel_BookMaster] WITH(NOLOCK) 
  where IsCancelled=1 and [PassengerEmail]=@EmailID )H  
    
    
   
  
    select pax.*,pay.amount from #hotelbookcanc  
    pax  
  inner join dbo.Paymentmaster pay WITH(NOLOCK) on pax.orderId=pay.order_id  
   and pay.Type='Hotel';  
  
  SELECT  [Salutation]  
      ,[FirstName]  
      ,[LastName]  
       
       
      ,[book_fk_id]  
      ,[orderId]  
      ,[IsCancelled]  
      ,[IsBooked]  
      ,[inserteddate]  
        
  FROM [dbo].[Hotel_Pax_master] WITH(NOLOCK)   
    
  where IsCancelled=1 and book_fk_id in (select [pkId] from #hotelbookcanc)  
    
  
  drop table #hotelbookcanc;   
 end  
END  
  
  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetBookingHistorywithHotel] TO [rt_read]
    AS [dbo];

