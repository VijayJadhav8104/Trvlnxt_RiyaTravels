CREATE Procedure [dbo].[Sp_UpdateRescheduleStatusForOldRiyaPNR]
@OldRiyaPNR nvarchar(20),
@NewRiyaPNR nvarchar(20),
@AirlinePNR nvarchar(20)=null,
@AgentID int,
@GDSPNR nvarchar(20)=null
as
begin

Declare @Aircode nvarchar(20)
Declare @IssueBy nvarchar(30)
set @Aircode=(select top 1 aircode from tblBookMaster where riyapnr=@OldRiyaPNR)
set @IssueBy=(select top 1 operatingCarrier from tblBookMaster where riyapnr=@OldRiyaPNR)


--Added on 28-06-2021
Declare @OldAirlinePNR nvarchar(30)
set @OldAirlinePNR = ( select top 1 airlinePNR from tblBookItenary where fkBookMaster in(select pkId from tblBookMaster where riyapnr=@OldRiyaPNR))

Declare @FareType nvarchar(40)
Declare @Baggage nvarchar(30)
Declare @Country nvarchar(30)

set @FareType=(select top 1 FareType from tblBookMaster where riyapnr=@OldRiyaPNR)
set @Baggage=(select top 1 baggage from tblPassengerBookDetails tpbd left join tblBookMaster tbm on tpbd.fkBookMaster=tbm.pkId where tbm.riyapnr=@OldRiyaPNR)
set @Country=(select top 1 Country from tblBookMaster where riyapnr=@OldRiyaPNR)

--End

Update tblBookMaster set BookingStatus=8 where riyapnr=@OldRiyaPNR
Update RescheduleData set Status=8 where RiyaPNR=@OldRiyaPNR

--Commented 28-06-2021
	--Update tblBookMaster set IssueDate=GETDATE(),GDSPNR=@GDSPNR,IsBooked=1,AgentID=@AgentID,BookingStatus=1,operatingCarrier=@IssueBy  where riyapnr=@NewRiyaPNR

	--Update tblBookItenary set airlinePNR=@AirlinePNR, airCode=@Aircode where fkBookMaster in(select pkId from tblBookMaster where riyaPNR=@NewRiyaPNR)
--End 

--Added on 28-06-2021
	Update tblBookMaster set IssueDate=GETDATE(), GDSPNR=@GDSPNR, IsBooked=1, AgentID=@AgentID, BookingStatus=1, operatingCarrier=@IssueBy,FareType=@FareType,
	Country=@Country,	 PreviousRiyaPNR=@OldRiyaPNR  where riyapnr=@NewRiyaPNR

	Update tblBookItenary set airlinePNR=@AirlinePNR, airCode=@Aircode,PreviousAirlinePNR=@OldAirlinePNR 
	where fkBookMaster in(select pkId from tblBookMaster where riyaPNR=@NewRiyaPNR)
	
	Update tpbd set baggage=@Baggage from tblPassengerBookDetails tpbd left join tblBookMaster tbm on tpbd.fkBookMaster=tbm.pkId where tbm.riyapnr=@NewRiyaPNR

	Declare @PM_OrderID nvarchar(50)
	Set @PM_OrderID = (select top 1 orderId from tblBookMaster where riyaPNR=@NewRiyaPNR)
	Update Paymentmaster set currency= (select top 1 currency from Paymentmaster pm inner join tblBookMaster t on pm.order_id=t.orderId where t.riyaPNR= @OldRiyaPNR) 
	where order_id = @PM_OrderID
--End
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateRescheduleStatusForOldRiyaPNR] TO [rt_read]
    AS [dbo];

