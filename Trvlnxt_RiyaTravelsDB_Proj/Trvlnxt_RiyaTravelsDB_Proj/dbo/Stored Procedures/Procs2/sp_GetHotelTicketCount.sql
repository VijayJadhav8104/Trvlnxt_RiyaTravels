--Edited by Gaurav and Created by Pranay Date:14-04-22          
CREATE PROCEDURE [dbo].[sp_GetHotelTicketCount]           
AS            
BEGIN         
select          
        
case         
        
when (ISNULL(Al.userTypeID,2) = '2') then 'B2B'    
  
  
when (ISNULL(Al.userTypeID,2) = '3') then 'Marine'     
        
when (ISNULL(Al.userTypeID,2) = '4') then 'Holidays'     
  
  
        
end as 'UserType',         
        
        
case when (HB.BookingCountry = 'IN') then 'INDIA'         
        
when (HB.BookingCountry = 'US') then 'USA'         
         
when (HB.BookingCountry = 'CA') then 'CAD'         
when (HB.BookingCountry = 'AE') then 'UAE'         
end as 'Country',          
        
CurrencyCode as 'Currency',          
        
    
SUM(Case when HSHVouchred.max_id is not null then DisplayDiscountRate else 0 end) as 'Voucher Amount',        
        
        
SUM(Case when HSHVouchred.max_id is not null then 1 else 0 end) as 'Voucher Count',       
        
        
SUM(Case when HSH.FKStatusId = 7 AND HSH.ISactive=1 and HSHCancel.max_id is not null then DisplayDiscountRate else 0 end)        
as [Cancellation Amount],        
        
        
SUM(Case when HSH.FKStatusId = 7 AND HSH.ISactive=1 and HSHCancel.max_id is not null then 1 else 0 end)        
as [Cancellation Count],        
        
(        
        
SUM(Case when HSHVouchred.max_id is not null then HB.DisplayDiscountRate else 0 end)      
        
-         
        
SUM(Case when HSH.FKStatusId = 7 AND HSH.ISactive=1 and HSHCancel.max_id is not null then DisplayDiscountRate else 0 end)        
        
) AS [Net Total]        
        
from Hotel_BookMaster  HB WITH(NOLOCK)       
        
LEFT JOIN agentLogin AL WITH(NOLOCK) ON  AL.UserID = HB.RiyaAgentID         
        
INNER JOIN Hotel_Status_History HSH WITH(NOLOCK) ON HSH.FKHotelBookingId = HB.pkId  AND HSH.ISactive=1     
    
    
LEFT JOIN(        
        
    select FKHotelBookingId,max(id) as max_id from Hotel_Status_History as cc        
        
            
        where cc.FKStatusId=4        
        
group by FKHotelBookingId) as HSHVouchred     
    
 ON HSHVouchred.FKHotelBookingId = HB.pkId    
        
LEFT JOIN(        
        
    select FKHotelBookingId,max(id) as max_id from Hotel_Status_History as cc        
        
            
        where cc.ISactive=0         
        
        and cc.FKStatusId=4        
        
group by FKHotelBookingId) as HSHCancel        
        
 ON HSHCancel.FKHotelBookingId = HB.pkId          
        
        
where         
        
Convert(date, HB.inserteddate) >= Convert(date, GETDATE()-1)          
          
and HSH.FkStatusId in (4,7)          
        
--and hb.pkId=3374        
        
group by Al.userTypeID,HB.BookingCountry,HB.CurrencyCode       
        
        
order by 1 desc , 2 asc, 3 desc;        
        
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetHotelTicketCount] TO [rt_read]
    AS [dbo];

