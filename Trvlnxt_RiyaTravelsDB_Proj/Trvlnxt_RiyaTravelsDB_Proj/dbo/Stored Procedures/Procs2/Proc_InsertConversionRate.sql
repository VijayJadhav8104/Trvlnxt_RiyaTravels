CREATE Procedure Proc_InsertConversionRate          
@BookingPkId int,          
@FromCurrency varchar(50)=null,          
@ToCurrency varchar(50)=null,          
@ROEValue float=0,        
@SupplierUrl varchar(MAX)=null,      
@MarkupAmount float=0,    
@FinalROE float=0,
@CheckInDate datetime=null,
@CheckOutDate datetime=null
As          
Begin          
 Declare @RiyaPNR varchar(100)          
 Select @RiyaPNR=riyaPNR from Hotel_BookMaster where pkId=@BookingPkId          
 --update Hotel_BookMaster set ROEValue=@ROEValue,SupplierBookingUrl=@SupplierUrl,MarkupAmount=@MarkupAmount,FinalROE=@FinalROE where pkId=@BookingPkId  
 if(@CheckInDate IS NOT NULL AND @CheckOutDate IS NOT NULL)
	Begin
		update Hotel_BookMaster set ROEValue=@ROEValue,SupplierBookingUrl=@SupplierUrl,MarkupAmount=@MarkupAmount,FinalROE=@FinalROE,SupplierCheckInDate=@CheckInDate,SupplierCheckOutDate=@CheckOutDate where pkId=@BookingPkId        
	END
	Else
	Begin
		update Hotel_BookMaster set ROEValue=@ROEValue,SupplierBookingUrl=@SupplierUrl,MarkupAmount=@MarkupAmount,FinalROE=@FinalROE where pkId=@BookingPkId 
	END
 insert into Hotel_ROE_Booking_History(FkBookId,BookingRefNo,FromCurrency,ToCurrency,FkROE_Id,Rate,CreateDate)          
 values(@BookingPkId,@RiyaPNR,@FromCurrency,@ToCurrency,0,@ROEValue,GETDATE())          
End