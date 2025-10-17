--select  cast('01-Jul-2024' as date)    
-- exec sp_GetVccForCancelation 'TNHAPI00048521',''    
CREATE proc sp_GetVccForCancelation      
    
                   @bookingID varchar(max)= null  
                   
    
as      
begin     
SELECT       
       HB.inserteddate                       AS 'Booking_date',      
           
    bookingreference                      AS 'Booking_ID',      
       supplierreferenceno                   AS 'Supplier_Booking_ID',      
       suppliername                          AS 'suppliername',      
       currentstatus                         AS 'Supplier_Status',      
           
    hotelname                             AS 'Hotel_Name',      
       ( HB.leadertitle + ' ' + HB.leaderfirstname + ' '      
         + HB.leaderlastname + '' )          AS PassengerName,      
       -- (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName+ ' ' )  as PassengerName,                                   
       HB.checkindate                        AS 'Check_In',      
       HB.checkoutdate                       AS 'Check_Out',      
       CASE      
         WHEN HB.supplierrate IS NULL THEN 0      
         ELSE HB.supplierrate      
       END                                   AS 'VccAmt',      
       HB.suppliercurrencycode               AS 'Vcc_Currency',      
           
        
       Substring(ltrim(rtrim(number)), Len(ltrim(rtrim(number))) - 3, 4) AS 'Vcc_CardNo',      
       HCCD.cardtype                         AS 'CardType'   ,  
    
    hb.AccountId  
                                                 
FROM   hotel_bookmaster HB WITH (nolock)      
       --inner join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id                                         
       INNER JOIN hotel.tblapicreditcarddeatils HCCD WITH (nolock)      
               ON Hb.bookingreference = HCCD.bookingid       
    
WHERE -- suppliername in('HyperGuestNative')  
  
 --and 
 HB.BookingReference =@bookingID  
    
   End