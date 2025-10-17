

CREATE procedure [dbo].[SP_InsertPromoCode]


@UserType varchar(50),
@Promocode varchar(50),
@MultiplePromocode varchar(50),
@PromoType varchar(50),
@IncludeFlat numeric(18,2),
--@Min numeric(18,2),
--@Max numeric(18,2),
--@Discount numeric(18,2),
@dt Type_PromoDiscount Readonly,
@ServiceType varchar(50),
@FKID int

as
begin

Insert into DrecPromoCode
(

UserType,
PromoCode,
MultiplePromoCode,
Promotype,
IncludeFlat,
Min,
Max,
Discount,
ServiceType,
FKID

)
--values
--(
--@UserType ,
--@Promocode ,
--@MultiplePromocode ,
--@PromoType ,
--@IncludeFlat ,
--@Min ,
--@Max ,
--@Discount ,
--@ServiceType ,
--@FKID 
--)

select @UserType,@Promocode,@MultiplePromocode,@PromoType,@IncludeFlat,Minimum,Maximum,Discount,@ServiceType,@FKID from  @dt

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertPromoCode] TO [rt_read]
    AS [dbo];

