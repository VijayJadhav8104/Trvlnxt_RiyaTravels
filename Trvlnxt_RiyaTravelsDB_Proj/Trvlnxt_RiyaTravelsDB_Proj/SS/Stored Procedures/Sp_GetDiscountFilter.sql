           
--============================================                
-- Author : Sana                
-- Crated Date : 12/05/2022                
-- Description : To get Cruise Flat               
-- Sp_GetCruiseDiscountDetails null, null                
--============================================                
                
                
create proc [SS].Sp_GetDiscountFilter                
@UserType varchar(50)=null,                
@MarketPoint varchar(50)=null                
AS                
BEGIN                 
 select                 
 CD.Id,TravelValidityFrom,TravelValidityTo,SaleValidityTo,SaleValidityFrom,MarketPoint,              
 BookingType,ServiceType,CD.isActive,CreatedDate,ModifiedDate,TimeSlotFrom,TimeSlotTo,ReservationType,MU.UserName as 'CreatedBy',              
 case              
 when UserType=1 then 'B2C'               
 when UserType=2 then 'B2B'               
 when UserType=3 then 'Marine'               
 when UserType=4 then 'Holiday'              
 when UserType=5 then 'RBT'               
 when UserType=1245 then 'External Client'               
 else 'NA'              
end  as 'UserType'               
              
 from [SS].tbl_SS_Discount  CD              
 left join mUser MU on Mu.ID=CD.CreatedBy              
 where                
  (CD.UserType = @UserType or @UserType='' or @UserType=null ) and                 
  (CD.MarketPoint = @MarketPoint or @MarketPoint='' or @MarketPoint=null )                
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[Sp_GetDiscountFilter] TO [rt_read]
    AS [DB_TEST];

