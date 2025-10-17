
CREATE PROCEDURE [dbo].[Sp_GetVendorFareType]                
 @VendorName varchar(20)        
 ,@OfficeId varchar(100)                      
AS                      
BEGIN                      
          
 DECLARE @faretypeid Varchar(max)=''                    
        
 SELECT @faretypeid = Value FROM mVendorCredential                   
 WHERE VendorId = (SELECT ID FROM mVendor                  
    WHERE REPLACE(UPPER(VendorName),' ','') = REPLACE(UPPER(@VendorName),' ','') AND IsDeleted = 0 AND IsActive = 1)                   
 AND FieldName = 'Fare Type'                     
 AND OfficeId = @OfficeId          
 AND IsActive=1                 
                    
 SELECT ID        
 , FareName        
 , FareType        
 , ProductClass        
 , International        
 , Domestics          
 , FareIndicator        
 , FareColor   
 ,InternationalCabin
 ,DomesticsCabin
,UPPER(ISNULL(Refundable,'')) AS Refundable    
,IsBussinessClass    
,Cabin  
 FROM mFareTypeByAirline         
 WHERE ID IN (SELECT Data FROM sample_split((@faretypeid), ','))                 
 --or (Vendor=@VendorName and ProductClass='RTS')                   
END   
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorFareType] TO [rt_read]
    AS [dbo];

