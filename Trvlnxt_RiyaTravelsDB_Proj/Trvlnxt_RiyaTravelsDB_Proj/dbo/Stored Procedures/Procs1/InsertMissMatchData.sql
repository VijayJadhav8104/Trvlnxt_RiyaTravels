CREATE PROCEDURE InsertMissMatchData
@pkId BIGINT=null,
@book_Reference VARCHAR(100)=null,
@CurrentStatus Varchar(300)=null,
@QutechCurrentStatus Varchar(300)=null,
@InsertDate datetime=null,
@AgentId varchar(100)=null,
@MainAgentId varchar(100)=null,
@CheckinDate datetime=null,
@CancellationDeadLine Varchar(500)=null,
@HotelHistoryCurrentStatus Varchar(500)=null,
@PaymentMode int=0
AS              
BEGIN
insert into BookingStatusMissMatchData(PKID,BookingReference,CurrentStatus,QutechCurrentStatus,InsertDate,AgentId,MainAgentId,CheckInDate,CancellationDeadLine,HotelHistoryCurrentStatus,DataInsertDate,PaymentMode) values(@pkId,@book_Reference,@CurrentStatus,@QutechCurrentStatus,@InsertDate,@AgentId,@MainAgentId,@CheckinDate,@CancellationDeadLine,@HotelHistoryCurrentStatus,GETDATE(),@PaymentMode)
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertMissMatchData] TO [rt_read]
    AS [dbo];

