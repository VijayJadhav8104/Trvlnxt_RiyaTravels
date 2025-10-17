
-- execute Update_HotelCancelCharges 'RT1004458',27349.9
CREATE Proc Update_HotelCancelCharges
@bookId varchar(10),
@charges  decimal(10,2)=null
As
begin
Update Hotel_BookMaster set CancellationCharge=@charges 
where book_Id=@bookId

-- select AppliedAgentCharges from Hotel_BookMaster where book_Id=@bookId -- Old Code
select AppliedAgentCharges from Hotel_BookMaster where BookingReference=@bookId    -- Changes by Altamash. book_Id and BookingReferenceNo miss match.

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_HotelCancelCharges] TO [rt_read]
    AS [dbo];

