







CREATE proc [dbo].[GetRecords_HotelBookMaster]

@ID int
as
begin

select expected_prize,ContractComment,IsCancelled,HotelName, TotalCharges,CurrencyCode,CountryName,CancelHours,CancelDate,CityId,HotelAddress1,TotalAdults,TotalChildren,TotalRooms,SelectedNights,CancellationCharge,CheckInDate,CheckOutDate, LeaderFirstName

+' '+ LeaderLastName as Name,PassengerPhone,PassengerEmail,book_message,TotalCharges,riyaPNR,[QtechCancelCharge],QtechTotalCharges,QtechAppliedAgentCharges,QtechAppliedAgentRate,SupplierName
,BufferCancelDate,
beforecancelcharge,
aftermarkupcancelcharges

  from Hotel_BookMaster where pkId= @ID

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecords_HotelBookMaster] TO [rt_read]
    AS [dbo];

