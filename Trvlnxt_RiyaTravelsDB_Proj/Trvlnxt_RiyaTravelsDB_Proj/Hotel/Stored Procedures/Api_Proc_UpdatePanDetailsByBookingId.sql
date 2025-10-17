CREATE PROCEDURE [Hotel].[Api_Proc_UpdatePanDetailsByBookingId]                                                                                                  
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
 DECLARE @Nationality VARCHAR(100)                                                  
 DECLARE @DestinationCountryCode VARCHAR(100)                                                  
 DECLARE @NameCount INT              
                                                                    
 /*commented for not going live*/                                                                               
 SELECT @Nationality=Nationalty,@DestinationCountryCode=DestinationCountryCode FROM Hotel_BookMaster hb WITH (NOLOCK) LEFT JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                                                     
 WHERE BookingReference=@BookingReference AND Refundable=1 AND IsLeadPax=1 AND (PassportNum IS NULL OR PassportNum='')                       
 AND (IssueDate IS NULL OR IssueDate='') AND (Expirydate IS NULL OR Expirydate='') AND (PassPortDOB IS NULL OR PassPortDOB='')                           
                           
 IF (UPPER(@Nationality)!='IN' AND (UPPER(@DestinationCountryCode)!=UPPER(@Nationality) OR UPPER(@DestinationCountryCode)=UPPER(@Nationality))                                           
 AND ((@PassportName IS NULL OR @PassportName='') OR (@PassportNum IS NULL OR @PassportNum='') OR (@IssueDate IS NULL OR @IssueDate='') OR (@ExpiryDate IS NULL OR @ExpiryDate='')                       
 OR (@PassPortDOB IS NULL OR @PassPortDOB='')))                                                                         
 BEGIN                                                                        
  SELECT 'passport details mandatory for lead pax with international nationality'                                                                 
  PRINT 1                                                                
 END                                                                   
 ELSE IF (UPPER(@Nationality)!='IN' AND (UPPER(@DestinationCountryCode)!=UPPER(@Nationality) OR UPPER(@DestinationCountryCode)=UPPER(@Nationality))                                            
 AND ((@PassportNum IS NOT NULL OR @PassportNum!='') AND (@IssueDate IS NOT NULL OR @IssueDate!='')                                           
 AND (@ExpiryDate IS NOT NULL OR @ExpiryDate!='') AND (@PassportDOB IS NOT NULL OR @PassportDOB!='')))                                                                 
 BEGIN                                                        
 PRINT 2                                                        
 SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id        
 WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hp.IsLeadPax=1     
 AND (((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PassportName, 2))=1) OR ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PassportName, 1))=1))                                              
  IF (@PaxId>0)                                          
  BEGIN                                                        
 UPDATE Hotel_Pax_master SET PassportNum=@PassportNum,Expirydate=@ExpiryDate,IssueDate=@IssueDate,PassPortDOB=@PassportDOB WHERE Id=@PaxId                                                                      
 SELECT 'passport details updated successfully'                                                                 
 PRINT 3                                          
  END                                                      
  ELSE                                                         
  BEGIN                                                        
 SELECT 'Passport name already exists or Passport name mismatch with lead pax first name, last name'                                                          
 PRINT 4                                                          
  END                                                    
 END                                                        
ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1 AND                       
((@PanCardName IS NULL OR @PanCardName='') OR (@Pancard IS NULL OR @Pancard='')))                                                        
BEGIN                                                        
 Select 'Pan card details mandatory for lead pax'                                                        
END                                                                   
ELSE IF EXISTS( SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1              
AND ((hp.PanCardName is null or hp.PanCardName='') AND (hp.Pancard is null or hp.Pancard=''))            
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1 OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1))                                                     
 BEGIN                                                                                                     
  --SELECT @NameCount=(SELECT count(item) from dbo.SplitString(@PanCardName,' ')) FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                     
  SELECT @NameCount=(SELECT count(DISTINCT(item)) from dbo.SplitString(RTRIM(@PanCardName),' ')) FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                                                                     
  WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1                   
  IF (@NameCount>1)                  
  BEGIN                  
  SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                     
  WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1                        
  AND (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1                      
  AND ((PanCardName IS NULL OR PanCardName='') AND (Pancard IS NULL OR Pancard=''))                      
  END                  
  ELSE                   
  BEGIN                  
  SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                                     
  WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1      
  AND (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1                          
  AND ((PanCardName IS NULL OR PanCardName='') AND (Pancard IS NULL OR Pancard=''))                     
  END                          
   IF (@PaxId>0)                                                            
   BEGIN                                                              
   UPDATE Hotel_Pax_master SET PanCardName= @PanCardName, Pancard=@Pancard WHERE Id=@PaxId AND IsLeadPax=1                                 
   SELECT 'Pan card details updated successfully'                                                                         
   PRINT 5                       
   END                                    
   ELSE                                    
   BEGIN                                    
   SELECT 'Pan card name mismatch with lead pax first name, last name'                                     
   PRINT 6                                        
   END                                    
 END         
 --ELSE IF NOT EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
 --WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1      
 --AND ((hp.PanCardName is null or hp.PanCardName='') AND (hp.Pancard is null or hp.Pancard=''))            
 --AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1 OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1))           
 --BEGIN      
 --SELECT 'PAN Card number and/or name is missing for the Lead Guest / LeadPAN2'       
 --PRINT 7          
 --END      
 ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
 WHERE hb.BookingReference=@BookingReference AND ((PanCardName IS NOT NULL OR PanCardName!='') AND (Pancard IS NOT NULL OR Pancard!='')) AND hb.Refundable=1                       
 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1)                                                    
  BEGIN                             
 Select top 1 'Pan card details already exists for ' + FirstName  + ' ' + LastName  FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
 WHERE hb.BookingReference=@BookingReference AND ((PanCardName IS NOT NULL OR PanCardName!='') AND (Pancard IS NOT NULL OR Pancard!='')) AND hb.Refundable=1                       
 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1                                  
 PRINT 7       
  END         
 ELSE IF EXISTS( SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1              
AND ((hp.PanCardName is null or hp.PanCardName='') AND (hp.Pancard is null or hp.Pancard=''))            
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=0 AND (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=0))                                                     
 BEGIN                                    
   SELECT 'Pan card name mismatch with lead pax first name, last name'                                     
   PRINT 8                                        
 END         
 ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id                       
 WHERE hb.BookingReference=@BookingReference  AND hb.Refundable=0)                                                        
  BEGIN                                                          
 SELECT 'Pan card or passport details not required'                           
  PRINT 9                                                        
  END                                                          
 /*commented for not going live*/                                          
END                                     
                                    
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Rahul Ajay Vaid'                                    
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Ranjit Ajay Singh'           
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Sachin Ajay Vaid'         
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Adil Pereira'                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Rohit'                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Sharma'                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005571','AKKPJ3445L','Vinod'                  
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005623','AZKPM2156Q','MATEEN MOHD MOJAN'      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00005622','AZKPM2156Q','RANJIT RAMSUNDER JAISWAL'