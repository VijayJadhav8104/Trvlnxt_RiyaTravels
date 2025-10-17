

-- Created Date :  14-12-2022          
-- Created By :  Akash Singh          
-- Details :   To Get Supplier id of Zentrum hub     
-- [Hotel].GetHotelBookingDetailsByID 'TNH00024140'  
--============================================          
CREATE PRoc [Hotel].GetHotelBookingDetailsByID -- Exec [Hotel].GetHotelBookingDetailsByID 'TNHAPI00000041'          
 @BookingID varchar(50)=''          
,@ClientBookingID varchar(50)=''          
As          
Begin          
   if(@BookingID !='')          
   begin          
   Select top 1 Value from [Hotel].ApiBookData where BookingId=@BookingID and [key]='BookingAmount'          
   Union all          
   Select top 1 Value from [Hotel].ApiBookData where BookingId=@BookingID and [key]='DeadlineDate'          
   union all        
   Select top 1 ISNULL(Value,0) from [Hotel].ApiBookData where BookingId=@BookingID and [key]='SupplierRate'      
   union all        
   Select top 1 ISNULL(Value,0) from [Hotel].ApiBookData where BookingId=@BookingID and [key]='TotalServieCharges'      

   end          
   if(@ClientBookingID !='')          
   begin          
   Select Top 1 BookingId from [Hotel].ApiBookData where ClientBookingID=@ClientBookingID --and [key]='BookingAmount'          
   end          
End  
   
