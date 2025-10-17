CREATE proc [dbo].[IsTicketNumberExist]--[dbo].[IsTicketNumberExist] '5ND82Q','6996410765'                        
@TicketNumber varchar(50) = null,            
@GDSPNR varchar(10) = null            
as                        
begin                       
                                     
 Select Riyapnr From tblPassengerBookDetails as pass inner join tblBookMaster as book            
 on pass.fkBookMaster = book.pkId            
 where (book.BookingStatus = '1' OR book.BookingStatus = '18') and book.IsBooked = '1' --and book.GDSPNR = @GDSPNR     
 and (SUBSTRING(pass.TicketNumber,1,10) LIKE '%' + SUBSTRING(@TicketNumber,1,10)  +'%' OR SUBSTRING(pass.ticketNum,1,10) LIKE '%' +  SUBSTRING(@TicketNumber,1,10) +'%')          
              
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsTicketNumberExist] TO [rt_read]
    AS [dbo];

