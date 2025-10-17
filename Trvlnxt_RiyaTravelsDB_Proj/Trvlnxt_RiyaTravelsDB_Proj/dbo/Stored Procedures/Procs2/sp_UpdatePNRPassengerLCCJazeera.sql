create PROCEDURE [dbo].[sp_UpdatePNRPassengerLCCJazeera]
	@PaxId	int,
	@PNR varchar(200)

AS
BEGIN
	UPDATE tblPassengerBookDetails SET ticketNum = @PNR,ticketnumber= @PNR
	WHERE pid = @PaxId

	declare @BookingId int

	Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId
	
	Update tblBookMaster set IsBooked = 1 where pkId = @BookingId


	
if((select count(*) from tblPassengerBookDetails where fkBookMaster=@BookingId)>1)
begin
create table #TempfkBookMaster
(
    id int IDENTITY(1,1),
    pid int,      
)


insert into #TempfkBookMaster select pid from tblPassengerBookDetails where fkBookMaster=@BookingId
  
  select * from #TempfkBookMaster

  DECLARE @totalRecords int=0
   select @totalRecords=count(*) from #TempfkBookMaster
   declare @PaxIdLoop int
   declare @primaryId int=1

   declare @ticketNumb nvarchar(50)
WHILE @totalRecords >=@primaryId
BEGIN
    print @totalRecords
	 select @PaxIdLoop=pid from #TempfkBookMaster where id=@primaryId
	 
	 if(@ticketNumb is null)
	 begin
	     select @ticketNumb=TicketNumber from tblPassengerBookDetails where  fkBookMaster=@BookingId and TicketNumber is not null
	end
		 update tblPassengerBookDetails set ticketNum=@ticketNumb+'-'+CONVERT(nvarchar(10), @primaryId),TicketNumber=@ticketNumb+'-'+CONVERT(nvarchar(10), @primaryId) where pid=@PaxIdLoop and fkBookMaster=@BookingId
	

	set @primaryId=@primaryId+1


END

END





END