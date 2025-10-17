CREATE proc [dbo].[Agent_ActiveDeactive_Promo]  
  
@ID int,  
@Flag bit,  
@UpdatedBy int=null  
as  
begin  
  
if (@ID >0)  
begin  
 update Flight_PromoCode  
 set Flag = @Flag  
 where ID = @ID  
end  
else  
begin  
 update Flight_PromoCode  
 set Flag = @Flag  
 where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UpdatedBy  AND IsActive=1)  
end  
end  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactive_Promo] TO [rt_read]
    AS [dbo];

