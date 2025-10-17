
CREATE PROCEDURE [dbo].[UpdateAirlinePNR]
@OrderId			varchar(30),
@AirlinePNR			varchar(50),
@FromSector			varchar(3)='',
@ToSector			varchar(3)=''
,@flag char(2)=''
,@TicketingPCC varchar(50) =null
,@CardID INT=NULL
AS BEGIN

if(@flag='M')
begin
UPDATE tblBookItenary SET airlinePNR = @AirlinePNR 
	WHERE orderId = @OrderId --AND frmSector = @FromSector AND toSector = @ToSector
end
else
begin
	UPDATE tblBookItenary SET airlinePNR = @AirlinePNR 
	WHERE orderId = @OrderId AND frmSector = @FromSector AND toSector = @ToSector
	end

	if(@TicketingPCC!='' or @TicketingPCC is not null)
	begin
	update tblBookMaster set TicketingPCC=@TicketingPCC
	where orderid=@OrderId
	end

	if(@CardID!='' or @CardID is not null)
	begin
	update Paymentmaster set CardID=CardID
	where order_id=@OrderId
	end
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateAirlinePNR] TO [rt_read]
    AS [dbo];

