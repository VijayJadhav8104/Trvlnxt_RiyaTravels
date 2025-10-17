



CREATE procedure [dbo].[SP_InsertFlat]

--@Min numeric(18,2),
--@Max numeric(18,2),
--@Discount numeric(18,2),

@dt Type_Discount Readonly,
@FKID int

as
begin

Insert into Flat
(

Min,
Max,
Discount,
FKID
)
select  Min,Max,Discount,@FKID from  @dt

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertFlat] TO [rt_read]
    AS [dbo];

