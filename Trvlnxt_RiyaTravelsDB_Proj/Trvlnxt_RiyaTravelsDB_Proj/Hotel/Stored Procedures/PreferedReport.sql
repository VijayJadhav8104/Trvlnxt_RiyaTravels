CREATE PROC hotel.PreferedReport          
 @StartDate VARCHAR(200) = '',          
 @EndDate VARCHAR(200) = '',    
 @SearchBy varchar(20)='',    
 @BookingId varchar(200)=''    
      
AS          
BEGIN          
      
  if(@SearchBy='0')    
  begin    
    SELECT   distinct      
       
        HB.Bookingreference,          
        FORMAT(CAST(HB.InsertedDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS BookingDate,         
        FORMAT(CAST(HB.CheckInDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CheckInDate,         
        FORMAT(CAST(HB.CheckOutDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CheckOutDate,         
        FORMAT(CAST(HB.CancellationDeadLine AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CancellationDeadLine,         
      
        HB.HotelId,          
        HB.HotelName,          
        HB.CityName,          
        HB.CountryName,          
        HB.SelectedNights,          
        HB.TotalRooms,          
        HB.CurrentStatus,          
        HB.DisplayDiscountRate,          
        HB.CurrencyCode,          
       cast((HB.DisplayDiscountRate * HB.FinalROE) as decimal(18,2)) as 'BookingAmt_INR',           
      
        SM.SupplierName AS BookedSupplier,          
      
          CASE 
    WHEN HB.Refundable = 1 THEN 
        'Refundability: Refundable | Room: ' + ISNULL(RD.RoomName, '') + ' | Meal: ' + ISNULL(RD.Meal, '')
    ELSE 
        'Refundability: Non-Refundable | Room: ' + ISNULL(RD.RoomName, '') + ' | Meal: ' + ISNULL(RD.Meal, '')
END AS BookedInfo,       
      
        HD.SupplierName AS PrefredSupplier,          
       
       cast(HD.TotalRate as decimal(18,2))  AS Quote,          
       cast(HD.TotalRate * FinalROE as decimal(18,2)) AS PrefredRateINR,          
        ISNULL(QuoteAgg.RoomName, '') AS RoomName,          
        ISNULL(QuoteAgg.Meal, '') AS Meal,          
       ISNULL(QuoteAgg.Refundability, '') AS Refundability,          
   cast((HD.TotalRate /((HB.SelectedNights* HD.noofRooms))) as decimal(18,2)) as Prefered_PRPN,      
        HB.SearchApiId AS CID          
      
    FROM Hotel_BookMaster HB WITH (NOLOCK)          
      
    LEFT JOIN B2BHotelSupplierMaster SM WITH (NOLOCK)       
        ON  HB.SupplierPkId =SM.Id      
 LEFT Join Hotel_Room_master RM with(nolock) on HB.pkId= RM.book_fk_id       
 Inner Join Hotel.PrefrenceBookingHotelDetails  HD WITH (NOLOCK)  on HB.BookingReference=HD.BookingId      
                
      
    LEFT JOIN (      
        SELECT PB.BookingId,      
            STRING_AGG(PB.RoomName, ', ') AS RoomName,      
            STRING_AGG(PB.Meal, ', ') AS Meal,      
            STRING_AGG(PB.Refundability, ', ') AS Refundability      
        FROM Hotel.PrefranceBookDetails PB  WITH (NOLOCK)      
  inner join Hotel_BookMaster HB with(nolock) on HB.BookingReference=PB.BookingId      
        GROUP BY PB.BookingId      
    ) AS QuoteAgg       
        ON HD.BookingId = QuoteAgg.BookingId          
        
    LEFT JOIN (      
        SELECT HBB.pkId,      
         RMM.book_fk_id,      
            STRING_AGG(RMM.RoomDiscription, ', ') AS RoomName,      
            STRING_AGG(RMM.RoomMealBasis, ', ') AS Meal      
        FROM Hotel_BookMaster HBB  WITH (NOLOCK)      
  inner join Hotel_Room_master RMM with(nolock) on HBB.pkId=RMM.book_fk_id      
        GROUP BY RMM.book_fk_id,HBB.pkId      
    ) AS RD      
        ON HB.pkId = RD.pkid         
      
    WHERE CAST(HB.InsertedDate AS DATE) BETWEEN       
 cast(@StartDate as date) and cast(@EndDate as Date)    
 --CAST(GETDATE() - 1 AS DATE) AND CAST(GETDATE() AS DATE);          
   end    
       
   else if (@SearchBy='1')    
   begin    
    SELECT   distinct      
       
        HB.Bookingreference,          
        FORMAT(CAST(HB.InsertedDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS BookingDate,         
        FORMAT(CAST(HB.CheckInDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CheckInDate,         
        FORMAT(CAST(HB.CheckOutDate AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CheckOutDate,         
        FORMAT(CAST(HB.CancellationDeadLine AS DATETIME), 'dd MMM yyyy hh:mm tt') AS CancellationDeadLine,         
      
        HB.HotelId,          
        HB.HotelName,          
        HB.CityName,          
        HB.CountryName,          
        HB.SelectedNights,          
        HB.TotalRooms,          
        HB.CurrentStatus,          
        HB.DisplayDiscountRate,          
        HB.CurrencyCode,          
       cast((HB.DisplayDiscountRate * HB.FinalROE) as decimal(18,2)) as 'BookingAmt_INR',           
      
        SM.SupplierName AS BookedSupplier,          
      
        CASE       
            WHEN HB.Refundable = 1 THEN       
                '<b>Refundability:</b> Refundable<br/><b>Room: </b>' + ISNULL(RD.RoomName, '') + '<br/><b>Meal: </b>' + ISNULL(RD.Meal, '')        
            ELSE       
                '<b>Refundability:</b> Non-Refundable<br/><b>Room: </b>' + ISNULL(RD.RoomName, '') + '<br/><b>Meal: </b>' + ISNULL(RD.Meal, '')        
        END AS BookedInfo,          
      
        HD.SupplierName AS PrefredSupplier,          
       
       cast(HD.TotalRate as decimal(18,2))  AS Quote,          
       cast(HD.TotalRate * FinalROE as decimal(18,2)) AS PrefredRateINR,          
        ISNULL(QuoteAgg.RoomName, '') AS RoomName,          
        ISNULL(QuoteAgg.Meal, '') AS Meal,          
       ISNULL(QuoteAgg.Refundability, '') AS Refundability,          
   cast((HD.TotalRate /((HB.SelectedNights* HD.noofRooms))) as decimal(18,2)) as Prefered_PRPN,      
        HB.SearchApiId AS CID          
      
    FROM Hotel_BookMaster HB WITH (NOLOCK)          
      
    LEFT JOIN B2BHotelSupplierMaster SM WITH (NOLOCK)       
        ON  HB.SupplierPkId =SM.Id      
 LEFT Join Hotel_Room_master RM with(nolock) on HB.pkId= RM.book_fk_id       
 Inner Join Hotel.PrefrenceBookingHotelDetails  HD WITH (NOLOCK)  on HB.BookingReference=HD.BookingId      
                
      
    LEFT JOIN (      
        SELECT PB.BookingId,      
            STRING_AGG(PB.RoomName, ', ') AS RoomName,      
            STRING_AGG(PB.Meal, ', ') AS Meal,      
            STRING_AGG(PB.Refundability, ', ') AS Refundability      
        FROM Hotel.PrefranceBookDetails PB  WITH (NOLOCK)      
  inner join Hotel_BookMaster HB with(nolock) on HB.BookingReference=PB.BookingId      
        GROUP BY PB.BookingId      
    ) AS QuoteAgg       
        ON HD.BookingId = QuoteAgg.BookingId          
        
    LEFT JOIN (      
        SELECT HBB.pkId,      
         RMM.book_fk_id,      
            STRING_AGG(RMM.RoomDiscription, ', ') AS RoomName,      
            STRING_AGG(RMM.RoomMealBasis, ', ') AS Meal      
        FROM Hotel_BookMaster HBB  WITH (NOLOCK)      
  inner join Hotel_Room_master RMM with(nolock) on HBB.pkId=RMM.book_fk_id      
        GROUP BY RMM.book_fk_id,HBB.pkId      
    ) AS RD      
        ON HB.pkId = RD.pkid         
      
    WHERE HB.BookingReference=@BookingId    
   end    
END 