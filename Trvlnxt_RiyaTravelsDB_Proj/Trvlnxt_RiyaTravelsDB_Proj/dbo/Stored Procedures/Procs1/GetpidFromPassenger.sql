CREATE PROCEDURE [dbo].[GetpidFromPassenger]
@OrderId varchar(50)
AS
BEGIN

Select pid From tblPassengerBookDetails where fkbookmaster IN (

Select pkId From tblBookMaster 
where orderId=@OrderId)
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetpidFromPassenger] TO [rt_read]
    AS [dbo];

