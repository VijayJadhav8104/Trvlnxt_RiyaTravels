CREATE PROCEDURE [dbo].[cancelHotelBook]                         
@bookid VARCHAR(30),                
@AgentId VARCHAR(30)='',
@MainAgentId VARCHAR(30)=null,
@MethodName VARCHAR(200)=null
                        
AS                        
BEGIN                        
                
begin transaction                  
begin try                  
 DECLARE @PKID AS INT
 DECLARE @AlertEmailid NVARCHAR(200) 
                        
 SET @PKID = (                        
   SELECT top 1 pkid                        
   FROM Hotel_BookMaster                        
   WHERE BookingReference = @bookid ---- Modified by Altamash                           
    -----WHERE @bookid = @bookid                            
   )                        
                       
  SET @AlertEmailid = (                            
   SELECT top 1 AlertEmail                            
   FROM Hotel_BookMaster                            
   WHERE BookingReference = @bookid ---- Modified by ketan marade                                                            
   )             
	  
 IF (@PKID IS NOT NULL OR @PKID != '')                        
 BEGIN                        
  UPDATE Hotel_BookMaster                        
  SET IsCancelled = 1                        
    ,SB_ReversalStatus=1                      
   ,CancelDate = getdate()                        
   ,book_message = 'Cancelled'     
   ,CurrentStatus = 'Cancelled'   
    ,CurrentDateSchedular = GetDate()    
  WHERE pkid = @PKID                        
         
  UPDATE Hotel_Pax_master                        
  SET IsCancelled = 1                        
  WHERE book_fk_id=  @PKID                     
           
  UPDATE Paymentmaster                        
  SET order_status = 'Cancelled'                        
  WHERE riyaPNR IN (                        
    SELECT riyaPNR                        
    FROM Hotel_BookMaster                        
    WHERE pkid = @PKID                        
    )                        
                        
  SELECT top 1 HB.expected_prize                       
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
   ,HB.TotalRooms                        
   ,HB.SelectedNights                        
   ,HB.CancellationCharge                        
   ,HB.CheckInDate                        
   ,HB.CheckOutDate                        
   ,HB.LeaderFirstName + ' ' + HB.LeaderLastName AS Name                        
   ,HB.PassengerPhone                 
   --,HB.PassengerEmail                        
   --,BR.AddrEmail as 'PassengerEmail' 
   ,CONCAT(BR.AddrEmail+',',isnull(@AlertEmailid,'tn.hotels@riya.travel')+',',isnull(mu.EmailID,'tn.hotels@riya.travel')) as 'PassengerEmail' --Ketan marade   
   ,HB.book_message                        
   ,HB.TotalCharges                        
   ,HB.riyaPNR                        
   ,HB.QtechCancelCharge                        
   ,HB.QtechTotalCharges                        
   ,HB.QtechAppliedAgentCharges                        
   ,HB.QtechAppliedAgentRate                        
   ,HB.SupplierName            
   ,NULL AS BufferCancelDate                        
   ,NULL AS beforecancelcharge                        
   ,NULL AS aftermarkupcancelcharges                        
   ,HB.B2BPaymentMode                        
   ,HB.RiyaAgentID                        
   ,HB.DisplayDiscountRate                        
   ,HB.BookingReference                        
   ,RM.RoomTypeDescription                        
   ,HB.pkid AS PkId                        
   ,BC.TDSDeductedAmount as TDSAmount                        
   ,BC.SupplierCommission                        
   ,BC.RiyaCommission                        
   ,BC.EarningAmount                        
   ,HB.inserteddate as BookingDate                    
   ,HB.orderId                    
   ,ROE.Rate                     
   ,isnull(HB.BookingCountry,'IN')  as BookingCountry 
   ,HB.SuBMainAgentID  
   
  FROM Hotel_BookMaster HB                        
  left join Hotel_Room_master RM on HB.pkId=RM.book_fk_id                        
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                        
  left join B2BHotel_Commission BC on HB.pkid=BC.Fk_BookId                        
  left Join Hotel_ROE_Booking_History ROE on ROE.FkBookId= Hb.pkid    
  left Join mUser mu ON HB.MainAgentID=mu.ID  
  WHERE HB.pkid = @PKID                        
  order by HB.inserteddate desc                        
                        
                        
                        
  UPDATE Hotel_Status_History                        
  SET IsActive = 0     
  WHERE FKHotelBookingId = @PKID                        
                        
  INSERT INTO Hotel_Status_History (                        
   FKHotelBookingId                        
   ,FkStatusId
   ,MainAgentId
   ,ModifiedDate                        
   ,ModifiedBy                        
   ,IsActive
   ,MethodName
   )                        
  VALUES (                        
   @PKID                        
   ,7
   ,@MainAgentId
   ,GETDATE()        
   ,@AgentId                        
   ,1
   ,@MethodName
   )                        
                        
 END                    
end                  
try                  
begin catch                  
    rollback transaction                  
end catch                  
                  
commit transaction                  
                  
END 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[cancelHotelBook] TO [rt_read]
    AS [dbo];

