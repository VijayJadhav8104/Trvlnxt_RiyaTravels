CREATE PROCEDURE [dbo].[Proc_PassengerDetails]      
 @MobileNo VARCHAR(20),      
 @EmailId VARCHAR(200)      
As      
BEGIN      
      
  IF EXISTS(SELECT TOP 1 * FROM Hotel_Pax_master WHERE Contact = @MobileNo OR Email = @EmailId)      
  BEGIN      
   SELECT DISTINCT LeaderTitle AS Salutation, LeaderFirstName AS FirstName, LeaderLastName AS LastName,    
   LeaderMiddleName AS MiddleName,PassengerPhone, PassengerEmail, ISNULL(HB.Nationalty,'Indian') AS Nationality    
  FROM Hotel_BookMaster HB    
   --INNER JOIN Hotel_Pax_master HPM ON HPM.book_fk_id = HB.pkId    
   --INNER JOIN Hotel_Nationality_Master HNM ON HNM.Code = HPM.Nationality     
  WHERE PassengerPhone = @MobileNo OR PassengerEmail = @EmailId AND    
    (LeaderTitle IS NOT NULL OR LeaderFirstName IS NOT NULL     
    OR LeaderLastName IS NOT NULL )     
    --ORDER BY pkId DESC      
  END      
END      