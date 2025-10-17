--=================================================                  
--Created By Shivkumar Prajapati                  
--Altered by Shivkumar Prajapati                  
--Altered by Altamash Khan                  
--exec [dbo].[AftercancelHotelBook]                  
--=================================================                  
CREATE PROCEDURE [dbo].[AftercancelHotelBook] @bookid VARCHAR(30)                
 ,@cancelCharge INT                
AS                
BEGIN                
 BEGIN TRAN                
                
 DECLARE @BOOKINGREFERENCE NVARCHAR(100)                
 DECLARE @BOOKIINGID NVARCHAR(100)
  DECLARE @AlertEmailid NVARCHAR(400) 
                
 SET @BOOKINGREFERENCE = (                
   SELECT TOP 1 BookingReference                
   FROM Hotel_BookMaster                
   WHERE BookingReference = @bookid                
   )                
 SET @BOOKIINGID = (                
   SELECT TOP 1 BookingReference                
   FROM Hotel_BookMaster                
   WHERE book_Id = @bookid                
   )                
 
 SET @AlertEmailid = (                          
   SELECT top 1 AlertEmail                          
   FROM Hotel_BookMaster                          
   WHERE BookingReference = @bookid ---- Modified by ketan marade                                                          
   )     

 IF (                
   @BOOKIINGID IS NOT NULL                
   OR @BOOKIINGID != ''                
   )                
 BEGIN                
  UPDATE Hotel_BookMaster                
  SET aftermarkupcancelcharges = @cancelCharge                
  WHERE book_Id = @bookid                
                
  SELECT HB.expected_prize                
   ,HB.ContractComment                
   ,HB.IsCancelled                
   ,HB.HotelName                
   ,HB.TotalCharges                
   ,HB.CurrencyCode                
   ,HB.CountryName                
   ,HB.CancelHours                
   ,HB.CancelDate                
   ,HB.CityId                
   ,HB.HotelAddress1                
   ,HB.TotalAdults                
   ,HB.TotalChildren                
   ,HB.BookingReference                
   --,BR.AddrEmail as 'PassengerEmail'
    ,CONCAT(BR.AddrEmail+',',isnull(@AlertEmailid,'tn.hotels@riya.travel')+',',isnull(mu.EmailID,'tn.hotels@riya.travel')) as 'PassengerEmail' --Ketan marade
   ,RM.RoomTypeDescription                
   ,HB.TotalRooms                
   ,HB.SelectedNights                
   ,HB.CancellationCharge                
   ,HB.CheckInDate                
   ,HB.CheckOutDate                
   ,HB.LeaderFirstName + ' ' + HB.LeaderLastName AS Name                
   ,HB.PassengerPhone                
   ,HB.PassengerEmail                
   ,HB.book_message                
   ,HB.TotalCharges                
   ,HB.riyaPNR                
   ,HB.QtechCancelCharge                
   ,HB.QtechTotalCharges                
   ,HB.QtechAppliedAgentCharges                
   ,HB.QtechAppliedAgentRate                
   ,HB.SupplierName                
   ,HB.BufferCancelDate                
   ,HB.beforecancelcharge                
   ,HB.aftermarkupcancelcharges                
   ,BC.TDSDeductedAmount as TDSAmount                
   ,BC.SupplierCommission                
   ,BC.RiyaCommission                
   ,BC.EarningAmount                
   ,HB.inserteddate as BookingDate             
   ,HB.orderId            
   ,ROE.Rate   --akash 19/01/2022        
   ,isnull(HB.BookingCountry,'IN')  as BookingCountry      
   ,HB.SuBMainAgentID    
  FROM Hotel_BookMaster HB                
  left join Hotel_Room_master RM on HB.pkId=RM.book_fk_id                
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                  
  left join B2BHotel_Commission BC on HB.pkid=BC.Fk_BookId            
  left Join Hotel_ROE_Booking_History ROE on ROE.FkBookId= Hb.pkid  --akash 19/01/2022          
  left Join mUser mu ON HB.MainAgentID=mu.ID                
  WHERE book_Id = @bookid                
 END                
                
 IF (                
   @BOOKINGREFERENCE IS NOT NULL                
   OR @BOOKINGREFERENCE != ''                
   )                
 BEGIN                
  UPDATE Hotel_BookMaster                
  SET aftermarkupcancelcharges = @cancelCharge                
  WHERE BookingReference = @BOOKINGREFERENCE                
                
  SELECT HB.expected_prize                
   ,HB.ContractComment                
   ,HB.IsCancelled                
   ,HB.HotelName       
   ,HB.TotalCharges                
   ,HB.CurrencyCode                
   ,HB.CountryName                
   ,HB.CancelHours                
   ,HB.CancelDate                
   ,HB.CityId                
   ,HB.HotelAddress1                
   ,HB.TotalAdults                
   ,HB.TotalChildren                
   ,HB.BookingReference                
   --,BR.AddrEmail as 'PassengerEmail' 
    ,CONCAT(BR.AddrEmail+',',isnull(@AlertEmailid,'tn.hotels@riya.travel')+',',isnull(mu.EmailID,'tn.hotels@riya.travel')) as 'PassengerEmail' --Ketan marade
   ,RM.RoomTypeDescription                
   ,HB.TotalRooms        
   ,HB.SelectedNights                
   ,HB.CancellationCharge                
   ,HB.CheckInDate                
   ,HB.CheckOutDate                
   ,HB.LeaderFirstName + ' ' + HB.LeaderLastName AS Name                
   ,HB.PassengerPhone                
   ,HB.PassengerEmail                
   ,HB.book_message             
   ,HB.TotalCharges                
   ,HB.riyaPNR                
   ,HB.QtechCancelCharge                
   ,HB.QtechTotalCharges                
   ,HB.QtechAppliedAgentCharges                
   ,HB.QtechAppliedAgentRate                
   ,HB.SupplierName                
   ,HB.BufferCancelDate                
   ,HB.beforecancelcharge                
   ,HB.aftermarkupcancelcharges                
   ,HB.B2BPaymentMode ---- Added Altamash                  
   ,HB.RiyaAgentID                
   ,HB.DisplayDiscountRate                
   ,HB.pkid AS PkId                
   ,BC.TDSDeductedAmount as TDSAmount                
   ,BC.SupplierCommission                
   ,BC.RiyaCommission                
   ,BC.EarningAmount                
   ,HB.inserteddate as BookingDate               
   ,HB.orderId            
   ,ROE.Rate   --akash 19/01/2022       
   ,isnull(HB.BookingCountry,'IN') as BookingCountry     
   ,HB.SuBMainAgentID  
  FROM Hotel_BookMaster HB                
  left join Hotel_Room_master RM on HB.pkId=RM.book_fk_id                
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                  
  left join B2BHotel_Commission BC on HB.pkid=BC.Fk_BookId         
  left Join Hotel_ROE_Booking_History ROE on ROE.FkBookId= Hb.pkid  --akash 19/01/2022          
   left Join mUser mu ON HB.MainAgentID=mu.ID           
  WHERE HB.BookingReference = @BOOKINGREFERENCE                
               
 END                
                
 COMMIT TRAN                
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AftercancelHotelBook] TO [rt_read]
    AS [dbo];

