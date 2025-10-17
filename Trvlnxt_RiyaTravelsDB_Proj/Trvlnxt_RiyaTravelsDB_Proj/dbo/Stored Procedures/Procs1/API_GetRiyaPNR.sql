CREATE PROCEDURE [dbo].[API_GetRiyaPNR]         
 @GDSPNR VARCHAR(10) = ''
 ,@ticketNumber varchar(50) = null    
AS              
BEGIN              
     Select top 1 b.riyaPNR as RiyaPNR 
	 From tblBookMaster b inner join tblPassengerBookDetails p on b.pkId =p.fkBookMaster              
     Where GDSPNR = @GDSPNR and b.BookingStatus = 1 and b.pkid = p.fkBookMaster
	 and (p.TicketNumber like '%'+@ticketNumber + '%' OR p.ticketNum like '%'+@ticketNumber + '%' )           
 END