
CREATE proc [dbo].[UpdateFlatDiscount]
(
@FDID  FDID READONLY
)
as
begin
update [dbo].[FlatDiscount] set [IsActive]=0 where [PKId]  IN (SELECT PKID from @FDID)
 end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateFlatDiscount] TO [rt_read]
    AS [dbo];

