CREATE PROCEDURE [Hotel].[Api_Proc_UpdatePanDetailsByBookingId_bkp_20052025]                                                                                    
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
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=1 OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=1))                                       
 BEGIN                                                                                      
  SELECT TOP 1 @PaxId=hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id         
  WHERE hb.BookingReference=@BookingReference AND hb.Refundable=1 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1 AND ((PanCardName IS NULL OR PanCardName='')         
  AND (Pancard IS NULL OR Pancard=''))                                                 
   IF (@PaxId>0)                                              
   BEGIN                                                
   UPDATE Hotel_Pax_master SET PanCardName= @PanCardName, Pancard=@Pancard WHERE Id=@PaxId AND IsLeadPax=1                          
   SELECT 'Pan card details updated successfully'                                                           
   PRINT 5                                                
   END                      
   ELSE                      
   BEGIN                      
 SELECT 'Pan card details already exists'                       
 PRINT 6                          
   END                      
 END                      
 ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb  WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id         
 WHERE hb.BookingReference=@BookingReference AND ((PanCardName IS NULL OR PanCardName='') AND (Pancard IS NULL OR Pancard='')) AND hb.Refundable=1         
 AND hb.IsPANCardRequired=1 AND hp.IsLeadPax=1                       
 AND ((SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 2))=0  OR (SELECT dbo.MatchPanCardName(FIRSTNAME + ' ' + LastName, @PanCardName, 1))=0))        
             
  BEGIN               
 Select 'Pan card name mismatch with lead pax first name, last name'                        
 PRINT 7                          
  END                          
 ELSE IF EXISTS(SELECT TOP 1 hp.ID FROM Hotel_BookMaster hb WITH (NOLOCK) JOIN Hotel_Pax_master hp WITH (NOLOCK) ON hb.pkId=hp.book_fk_id         
 WHERE hb.BookingReference=@BookingReference  AND hb.Refundable=0)                                          
  BEGIN                                            
 SELECT 'Pan card or passport details not required'             
  PRINT 8                                          
  END                                            
 /*commented for not going live*/                            
END                       
                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L','RANJIT RAMSUNER JAISWAL'                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L','KETAN GOPAL HIRAR'                      
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L','KETAN GOPAL'        
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L','KETAN'        
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L','RANJIT'        
--[Hotel].[Api_Proc_UpdatePanDetailsByBookingId]  'TNHAPI00004224','AKKPJ3445L',''