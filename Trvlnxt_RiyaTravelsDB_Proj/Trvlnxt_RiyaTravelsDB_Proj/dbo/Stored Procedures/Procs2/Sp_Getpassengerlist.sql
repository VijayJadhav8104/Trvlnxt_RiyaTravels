CREATE procedure Sp_Getpassengerlist
	@RiyaPNR varchar(8),
	@GDSPNR varchar(20)
as
begin
select 
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
'Confirmed' as Status,
t1.TicketNumber,
t1.baggage
 from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
where  t2.riyaPNR=@RiyaPNR and t2.GDSPNR=@GDSPNR and t1.isReturn=0
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Getpassengerlist] TO [rt_read]
    AS [dbo];

