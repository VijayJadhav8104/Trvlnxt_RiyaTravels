--- Created By : Aman Wagde:
-- Date of Creation : 02/04/2025
-- Details : fetch auto hcn that was updated by api and show on console details page.

CREATE Proc GetHotelHCN_Data
@Id int

as
Begin


select 
Isnull(HCN.HotelConfirmationNumber,'NA') as HCN_No

,ISnull(cast(HCN.CreatedDate as varchar(200)),'NA') as  CreatedDate


from 
[RiyaTravels].[Hotel].[HotelAutoHCN] HCN
Left Join Hotel_BookMaster HB on  HCN.BookingReference=HB.BookingReference
Where HB.pkId=@Id and HCN.IsActive=1 and HCN.HotelConfirmationNumber is not null and HCN.HotelConfirmationNumber !=''
End


--select * from hotel.HotelAutoHCN where BookingReference='TNHAPI00115869'