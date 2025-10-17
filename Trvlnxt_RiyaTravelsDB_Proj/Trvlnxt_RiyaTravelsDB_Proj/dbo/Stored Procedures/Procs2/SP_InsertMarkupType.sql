
create procedure [dbo].[SP_InsertMarkupType]

@OnBasic numeric(18,2),
@OnTax numeric(18,2),
@FKID int

as
begin

Insert into MarkupType
(

OnBasic,
OnTax,
FKID
)
values
(
@OnBasic ,
@OnTax ,
@FKID 

)

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertMarkupType] TO [rt_read]
    AS [dbo];

