CREATE PROCEDURE GetAERTicketList          
AS          
BEGIN          
    SELECT DISTINCT b.*        
    FROM tblBookMaster b         
    INNER JOIN tblPassengerBookDetails p         
        ON p.fkBookMaster = b.pkId         
    WHERE (b.IsBooked = 1 OR b.bookingstatus = 1) 
      AND (p.ticketNum IS NULL OR p.ticketNum = '') 
      AND LOWER(b.VendorName) IN ('aerticket', 'pkfares') 
      AND b.returnFlag = 0         
      --AND GDSPNR = '4FUEHN'             
      AND b.inserteddate_old >= GETDATE() - 1;          
END; 
