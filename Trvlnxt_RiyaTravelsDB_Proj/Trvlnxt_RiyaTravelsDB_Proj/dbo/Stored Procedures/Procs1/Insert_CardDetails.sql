          
CREATE PROCEDURE [dbo].[Insert_CardDetails]                   
@CardHolderName varchar(10)=null,                  
@CardNo char(16),                  
@Cvv varchar(30)=null,                  
@Expiry Datetime = null,                   
@FkBookingId varchar(30)=null,          
@Address1 varchar (100)=null,          
@Address2 varchar (100)=null,          
@Country varchar (100)=null,          
@City varchar (100)=null,          
@PostalCode int=0,        
@State varchar (100)=null,  
@CountryCode varchar (50)= null,
@CardType varchar(20)=null
              
AS BEGIN                  
                
INSERT INTO hotel.CardDetailsPayHotel                
VALUES (@FkBookingId, @CardHolderName, @CardNo,@Cvv,@Expiry,GETDATE(),@Address1,@Address2,@Country,@City,@PostalCode,@State,@CountryCode,@CardType);                
            
END 