

CREATE proc [dbo].[fetchFlatDiscount]
@Status bit
 as
 begin 
 select [PKId],[SectorType],[AirCode],[amount],[Insert_date],a.UserName,
 case when FlatDiscount.FlatDiscountType=0 then 'Per Pax' when FlatDiscount.FlatDiscountType=1 then 'Per Booking' else '' end as  FlatDiscountType,
 salesFrm_date,salesTo_date,travelFrm_date,travelTo_date,minFlatAmt,maxFlatAmt ,

 case when Country='IN' then 'India' when Country='US' then 'USA' when Country='CA' then 'Canada' else '' end as Country, FlatDiscount.Username as UserID

   from [dbo].[FlatDiscount]
 JOIN adminMaster A ON A.ID = FlatDiscount.UserId
  where IsActive=@Status
  order by [AirCode]
 End





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchFlatDiscount] TO [rt_read]
    AS [dbo];

