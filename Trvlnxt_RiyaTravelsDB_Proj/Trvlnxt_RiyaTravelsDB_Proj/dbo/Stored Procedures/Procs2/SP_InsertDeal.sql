



create procedure [dbo].[SP_InsertDeal]

@Basic numeric(18,2),
@BasicYQ numeric(18,2),
@NNB numeric(18,2),
@NNBYQ numeric(18,2),
@Flat numeric(18,2),
@FKID int

as
begin

Insert into Deal
(

Basic,
BasicYQ,
NNB,
NNBYQ,
Flat,
FKID
)
values
(
@Basic ,
@BasicYQ ,
@NNB ,
@NNBYQ ,
@Flat ,
@FKID 

)

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertDeal] TO [rt_read]
    AS [dbo];

