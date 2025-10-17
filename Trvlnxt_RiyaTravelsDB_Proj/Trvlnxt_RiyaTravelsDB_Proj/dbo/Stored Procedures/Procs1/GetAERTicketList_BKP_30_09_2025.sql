

CREATE PROCEDURE GetAERTicketList_BKP_30_09_2025         
AS          
BEGIN          
SELECT DISTINCT b.*        
FROM tblBookMaster b         
INNER JOIN tblPassengerBookDetails p         
ON p.fkBookMaster = b.pkId         
WHERE (b.IsBooked = 1 or b.bookingstatus=1) AND         
(p.ticketNum IS NULL OR p.ticketNum = '')AND         
LOWER(b.VendorName) = 'aerticket'        
and b.returnFlag=0         
--and GDSPNR='4FUEHN'             
AND b.inserteddate_old >= GETDATE()-1;          
          
END;        