create procedure Proc_InserBookingTaxses  
@FKBookingId int =0,  
@Amount float=0,  
@Discription varchar(300)=null  
As  
Begin  
 Insert into hotel.Hotel_BookingTax(FKBookId,Amount,Discription,InsertDate)  
 Values(@FKBookingId,@Amount,@Discription,Getdate())  
End