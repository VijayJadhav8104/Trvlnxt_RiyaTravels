CREATE PROCEDURE GetDefaultPCCMapping  
(    
      @OfficeID VARCHAR(50)    
)    
AS    
BEGIN   

SELECT CountryCode FROM tblDefaultPCCMapping (NOLOCK) WHERE PCC = @OfficeID  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetDefaultPCCMapping] TO [rt_read]
    AS [dbo];

