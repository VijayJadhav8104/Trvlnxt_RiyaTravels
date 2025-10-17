CREATE PROCEDURE [Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]                                                                                                              
 @BookingReference VARCHAR(150),                          
 @Pancard NVARCHAR(400)=NULL,                                                                                                              
 @PanCardName VARCHAR(200)=NULL,                                                                       
 @PassportName VARCHAR(200)=NULL,                                                                    
 @PassportNum VARCHAR(30)=NULL,                                                                                                          
 @IssueDate VARCHAR(100)=NULL,                                                                                                          
 @ExpiryDate VARCHAR(100)=NULL,                                                                    
 @PassportDOB VARCHAR(100)=NULL                                                                    
AS                                                                                                              
BEGIN                                                                                                              
                                                                            
DECLARE @PaxId INT                            
DECLARE @PkId INT                
DECLARE @NameCount INT                
                                                                                 
IF EXISTS( SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1                                                                        
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1 OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1))                                                                 
 BEGIN                    
  --SELECT @NameCount=(SELECT count(item) from dbo.SplitString(@PanCardName,' ')) FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
  SELECT @NameCount=(SELECT count(DISTINCT(item)) from dbo.SplitString(RTRIM(@PanCardName),' ')) FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                     
  WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1                  
  IF (@NameCount>1)                
  BEGIN                
 SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
 WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1                       
 AND (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1                    
 AND ((PanCardName IS NULL OR PanCardName='') AND (Pancard IS NULL OR Pancard=''))                
 --PRINT @PaxId                  
 PRINT 1                 
  END                
  ELSE                 
  BEGIN                
 SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
 WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1                       
 AND (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1                        
 AND ((PanCardName IS NULL OR PanCardName='') AND (Pancard IS NULL OR Pancard=''))                 
 --PRINT @PaxId                  
 PRINT 2                        
  END                        
                  
  IF (@PaxId>0)                                                                        
   BEGIN    
    DECLARE @LeaderFirstName VARCHAR(150)=NULL DECLARE @LeaderLastName VARCHAR(150)=NULL DECLARE @LeaderTitle VARCHAR(10)=NULL    
 SELECT @LeaderFirstName = FirstName,@LeaderLastName = LastName,@LeaderTitle=Salutation FROM Hotel_Pax_master WHERE Id=@PaxId     
 --PRINT @LeaderFirstName  PRINT @LeaderLastName  PRINT @LeaderTitle      
    
    SELECT @PkId =pkid FROM Hotel_BookMaster WITH (NOLOCK) WHERE BookingReference=@BookingReference                        
    UPDATE Hotel_Pax_master SET PanCardName= @PanCardName, Pancard=@Pancard,IsLeadPax=1 WHERE Id=@PaxId                                                   
    UPDATE Hotel_Pax_master SET IsLeadPax=0 WHERE IsLeadPax=1 AND book_fk_id=@PkId AND Id!=@PaxId    
 UPDATE Hotel_BookMaster SET LeaderFirstName=@LeaderFirstName, LeaderLastName=@LeaderLastName,LeaderTitle=@LeaderTitle WHERE BookingReference=@BookingReference    
    SELECT 'Pan card details updated successfully'                                                          
 --   PRINT @PkId                          
 --   PRINT @PaxId                
 PRINT 3                
   END                                                
  ELSE                             
   BEGIN                                                
    SELECT 'Pan card name mismatch with lead pax first name, last name'--'Pan card details already exists'                                                
    PRINT 4                                                    
   END                                                
 END        
 ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
 WHERE hb.BookingReference=@BookingReference  AND (hb.Refundable=0 OR hb.IsPANCardRequired=0))                                                                    
  BEGIN                                                                      
 SELECT 'Pan card not required'                                                                                    
 PRINT 5                        
  END              
 ELSE IF NOT EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                   
WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1                                                                        
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1 OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1))            
 BEGIN            
 SELECT 'Lead Guest / LeadPAN2 details do not exist in the guest list.'                
 PRINT 6             
 END                                                                     
 /*commented for not going live*/                                            
END                                                 
                                                
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445L','Sachin Ajay Vaid'                                                
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445B','Rahul Ajay Vaid'                                                
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445C','Adil Pereira'                                  
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445D','Rohit'                                  
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445E','Sharma'                                  
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005571','AKKPJ3445H','Vinod'              
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId_PanCardFor]  'TNHAPI00005627','AKKPJ3445H','TEST1 BOOKING'             
--select * from Hotel_Pax_master where book_fk_id=68302    
--select LeaderFirstName,LeaderLastName,LeaderTitle, * from hotel_bookmaster with (nolock) where bookingreference='TNHAPI00005571'