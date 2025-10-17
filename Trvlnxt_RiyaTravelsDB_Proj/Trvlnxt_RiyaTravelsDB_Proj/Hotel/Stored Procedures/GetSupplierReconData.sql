   --  Hotel.GetSupplierReconData 83129
CREATE PROCEDURE Hotel.GetSupplierReconData                          
 -- Add the parameters for the stored procedure here                          
                           
 @Id int=0                          
                          
AS                          
                              
BEGIN                              
      
      
select BookingReference,
SH.FkStatusId as BookingStatus,
isnull(HR.[Status],'Failed') as reconstatus
,isnull(ReconCounter,0) as ReconCounter  
from Hotel_BookMaster HB
left join Hotel.HotelReconRpt HR on HB.BookingReference=HR.BookID and HR.RowFlag='Supplier' and HR.IsActive=1
left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId and SH.IsActive=1
where pkid=@Id      
END 


select * from Hotel_Status_Master