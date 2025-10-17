              
              
CREATE procedure [dbo].[API_HoldPNRDetails] -- API_HoldPNRDetails '3JKYDJ'              
@GDSPNR varchar(50) = ''              
              
as begin              
              
Select b.OfficeID,b.riyaPNR,b.orderId,b.AgentID,b.VendorName,b.ROE,b.AgentROE,b.Country,b.AgentCurrency,p.amount,b.B2BMarkup,b.IsBooked,b.BookingStatus,b.TFBookingRef               
from tblBookMaster as b WITH (NOLOCK)               
inner join Paymentmaster as p on b.orderId = p.order_id              
where GDSPNR = @GDSPNR               
and totalFare > 0              
            
            
Select pid,paxFName,paxLName,paxType from tblPassengerBookDetails WITH (NOLOCK) where fkBookMaster IN (select pkId from tblBookMaster WITH (NOLOCK) where GDSPNR = @GDSPNR)                         
              
end