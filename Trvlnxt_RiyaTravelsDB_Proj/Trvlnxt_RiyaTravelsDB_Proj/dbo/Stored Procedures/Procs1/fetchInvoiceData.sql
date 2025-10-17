
CREATE proc [dbo].[fetchInvoiceData]
@Id int
as
begin
		BEGIN
			select P.paxFName+space(1)+P.paxLName as 'paxname',
				   B.riyaPNR as 'BookingId',
				   B.mobileNo as 'contact',
				   B.emailId as 'EmailId',
				   B.RegistrationNumber as 'GSTRegNo',
				   B.GDSPNR,--PNR No.
				   P.ticketNum, --ticket no.
				   t.frmSector+'/'+t.toSector as 'Sector',  --Sector Name		
				   B.deptTime as 'TravelDate', --Date of Travel
				   t.airCode+'-'+t.flightNo as 'FlightNo', --Flight No	
				   LEFT(t.cabin,1) as 'cabin',	-- class
				   p.basicFare as 'Base'

				   from
					tblBookMaster B
					inner join 
					tblBookItenary t
					on
					B.pkId=t.fkBookMaster

					inner join
					tblPassengerBookDetails P
					on
					B.pkId=p.fkBookMaster
					and
					B.pkId=@Id

		END
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInvoiceData] TO [rt_read]
    AS [dbo];

