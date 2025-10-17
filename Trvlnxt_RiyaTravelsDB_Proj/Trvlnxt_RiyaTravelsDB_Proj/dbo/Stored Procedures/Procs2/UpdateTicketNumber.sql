 
      
CREATE proc UpdateTicketNumber      
  @FirstName      VARCHAR(50) = NULL,      
  @LastName     VARCHAR(50) = NULL,      
  @PNR    VARCHAR(50) = NULL,      
  @TicketNumber VARCHAR(50) = NULL,      
  @TicketNum  VARCHAR(50) = NULL      
As      
BEGIN      
   UPDATE tblPassengerBookDetails       
   SET ticketNum=@TicketNum,TicketNumber=@TicketNumber       
   WHERE pid in (      
   SELECT pid FROM tblPassengerBookDetails p       
   INNER JOIN tblBookMaster b on b.pkId = p.fkBookMaster       
   WHERE paxFName=@FirstName and paxLName=@LastName and b.GDSPNR=@PNR);    
     
  -- If both TicketNum and TicketNumber are not NULL, update tblBookMaster
   IF (@TicketNum IS NOT NULL AND @TicketNumber IS NOT NULL)
   BEGIN
      UPDATE tblBookMaster   
      SET IsBooked = 1, BookingStatus = 1  
      WHERE GDSPNR = @PNR;
   END
END      