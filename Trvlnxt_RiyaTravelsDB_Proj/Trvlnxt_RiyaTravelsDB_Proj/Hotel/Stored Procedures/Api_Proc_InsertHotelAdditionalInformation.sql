CREATE PROCEDURE [Hotel].[Api_Proc_InsertHotelAdditionalInformation]                        
@RateCode VARCHAR(200)=null,                        
@RateText VARCHAR(MAX)=null,                            
@RateLabel VARCHAR(200)=null,                            
@book_fk_id BIGINT=0  
AS                        
BEGIN                        
 INSERT INTO Hotel.AdditionalInformation                        
 (book_fk_id,                        
 RateCode,                                               
 RateText,                        
 RateLabel)              
 VALUES                        
 (@book_fk_id,                        
 @RateCode,                        
 @RateText,                        
 @RateLabel)  
 SELECT   SCOPE_IDENTITY()  
END   