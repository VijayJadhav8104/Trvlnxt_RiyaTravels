CREATE procedure API_TrackIDExist -- API_TrackIDExist '20231011165332404204_430a61f9-fbd8-4056-9280-fcf7aa650d9b'          
@TrackID varchar(255) = ''          
          
as begin          
          
Select b.riyaPNR,b.GDSPNR ,b.orderId,b.OfficeID       
from tblBookMaster as b WITH (NOLOCK)           
where APITrackID = @TrackID and b.IsBooked = 1 and b.BookingStatus = 1         

    
Select top 1 b.riyaPNR,b.GDSPNR ,b.orderId,b.OfficeID       
from tblBookMaster as b WITH (NOLOCK)           
where APITrackID = @TrackID order by b.pkId desc
        
end