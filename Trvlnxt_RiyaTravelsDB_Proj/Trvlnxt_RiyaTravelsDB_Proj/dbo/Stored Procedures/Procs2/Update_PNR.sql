create proc [dbo].[Update_PNR] --'QF9GBG','dsf','PAX 589-5125479022/ET9W/INR3160/30JAN19/BOMI228DS/14360102'

@GDSPNR varchar(50),
@AirlinePNR varchar(100),
--@TicketNum varchar(500),
@BookingID varchar(50),

@IP varchar(50),
@UserID varchar(50),
@OrderID varchar(50),
@Device varchar(50)

as
begin

--declare
--@GDSPNR varchar(50)='QF9GBG',
--@AirlinePNR varchar(100)='dsf',
--@TicketNum varchar(500)='PAX 589-5125479022/ET9W/INR3160/30JAN19/BOMI228DS/14360102'



declare @ID int

select @ID = pkid from tblBookMaster where riyaPNR = @BookingID

--print @ID
update tblBookMaster
set IsBooked =1 , GDSPNR=@GDSPNR
where riyaPNR=@BookingID

--update tblPassengerBookDetails
--set ticketNum =@TicketNum 
--where fkBookMaster=@ID


update tblBookItenary
set airlinePNR =@AirlinePNR 
where fkBookMaster=@ID




insert into UpdatePNRHistory
(
vcrIP,
intUserID,
vcrOrderID,
vcrRiyaPNR,
vcrGDSPNR,
vcrActionRemark,
dtInsertedDate,
vcrDevice) values 
(
@IP,
@UserID,
@OrderID,
@BookingID,
@GDSPNR,
'PNR Update Successfully',
GETDATE(),
@Device
)

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_PNR] TO [rt_read]
    AS [dbo];

