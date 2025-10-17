
CREATE PROCEDURE [dbo].[UpdateIata]
@PaxId						int,
@Iata					varchar(8)
AS 
BEGIN

declare @orderid varchar(50)

select fkBookMaster from tblPassengerBookDetails where pid=@PaxId

select top 1 @orderid=orderId from tblBookMaster where pkId in (select fkBookMaster from tblPassengerBookDetails where pid=@PaxId)

update tblBookMaster
set IATA=@Iata
where orderId=	@orderid
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateIata] TO [rt_read]
    AS [dbo];

