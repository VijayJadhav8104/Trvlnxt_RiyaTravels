      
         
CREATE PROCEDURE [Insert_TrvlnxtBecomePartnerInquiryDetails]                          
    @InquiryGuid UNIQUEIDENTIFIER,                    
    @AgencyName varchar(50) = NULL,                                                      
    @EmailID varchar(50) = NULL,                                                       
    @MobileNo varchar(50) = NULL,                                                       
    @Message varchar(500) = NULL,                           
    @ContactPersonName varchar(100) = NULL,                           
    @TypeofEstablishment varchar(100) = NULL,                           
    @DirectorsName varchar(100) = NULL,                           
    @CompanyRegistrationNumber varchar(100) = NULL,                           
    @Address varchar(100) = NULL,                    
    @Country varchar(20) = NULL,                
    @City varchar(50) = NULL,                          
    @State varchar(50) = NULL,                          
    @PinCode varchar(50) = NULL,                
    @PanCardNo varchar(10) = NULL,              
    @CountryCode varchar(30) = NULL,             
    @Result INT OUTPUT                         
AS                                                             
BEGIN                                                            
    SET NOCOUNT ON;                          
                          
    IF EXISTS (SELECT 1 FROM tblTrvlnxtBecomePartnerInquiry WHERE InquiryGuid = @InquiryGuid)                        
    BEGIN                        
        UPDATE tblTrvlnxtBecomePartnerInquiry                        
        SET                        
           AgencyName = ISNULL(@AgencyName, AgencyName),                  
            EmailID = ISNULL(@EmailID, EmailID),                  
            MobileNo = ISNULL(@MobileNo, MobileNo),                  
            Message = ISNULL(@Message, Message),                  
            ContactPersonName = ISNULL(@ContactPersonName, ContactPersonName),                  
            TypeofEstablishment = ISNULL(@TypeofEstablishment, TypeofEstablishment),                  
            DirectorsName = ISNULL(@DirectorsName, DirectorsName),                  
            CompanyRegistrationNumber = ISNULL(@CompanyRegistrationNumber, CompanyRegistrationNumber),                  
            Address = ISNULL(@Address, Address),                  
            City = ISNULL(@City, City),                  
            State = ISNULL(@State, State),                  
            PinCode = ISNULL(@PinCode, PinCode),                
            Country = ISNULL(@Country, Country),              
            PanCardNo = ISNULL(@PanCardNo, PanCardNo),            
            CountryCode = ISNULL(@CountryCode, CountryCode) ,      
            UpdatedDate = GETDATE()        
      
        WHERE InquiryGuid = @InquiryGuid;              
              
            
       UPDATE [14.143.46.150,8081].[EKYCRevamp].[dbo].[OutsideGenratedLead]                        
            SET                  
            AgencyName = ISNULL(@AgencyName, AgencyName),                  
            EmailID = ISNULL(@EmailID, EmailID),                  
            MobileNo = ISNULL(@MobileNo, MobileNo),                  
            Message = ISNULL(@Message, Message),                  
            ContactPersonName = ISNULL(@ContactPersonName, ContactPersonName),                  
            TypeofEstablishment = ISNULL(@TypeofEstablishment, TypeofEstablishment),                  
            DirectorsName = ISNULL(@DirectorsName, DirectorsName),                  
            CompanyRegistrationNumber = ISNULL(@CompanyRegistrationNumber, CompanyRegistrationNumber),                  
            Address = ISNULL(@Address, Address),                  
            City = ISNULL(@City, City),                  
            State = ISNULL(@State, State),                  
            PinCode = ISNULL(@PinCode, PinCode),                
            Country = ISNULL(@Country, Country),              
  PanCardNo = ISNULL(@PanCardNo, PanCardNo),            
            CountryCode = ISNULL(@CountryCode, CountryCode) ,      
            UpdatedDate = GETDATE(),  
   SalesPerCode=Null  
      
        WHERE InquiryGuid = @InquiryGuid;           
                  
        SET @Result = 2;                        
    END                        
    ELSE                        
    BEGIN                        
           INSERT INTO tblTrvlnxtBecomePartnerInquiry (                    
            InquiryGuid,                     
            AgencyName,                     
             EmailID,                     
            MobileNo,                     
            Message,                     
            ContactPersonName,                    
            TypeofEstablishment,                     
            DirectorsName,                     
            CompanyRegistrationNumber,                    
            Address,                     
            City,                     
            State,                     
            PinCode,              
            Country,              
            PanCardNo,              
            CreatedDate,            
            CountryCode      
                  
                
        )                     
        VALUES (                    
            @InquiryGuid,                     
            @AgencyName,                     
            @EmailID,                     
            @MobileNo,                     
            @Message,                     
            @ContactPersonName,                    
            @TypeofEstablishment,                     
            @DirectorsName,                     
            @CompanyRegistrationNumber,                    
            @Address,                     
            @City,                     
            @State,                     
            @PinCode,                  
            @Country,                
            @PanCardNo,              
            GETDATE(),            
            @CountryCode     
       
                  
        );              
   INSERT INTO [14.143.46.150,8081].[EKYCRevamp].[dbo].[OutsideGenratedLead]                 
        (                          
            InquiryGuid,                     
            AgencyName,                     
            EmailID,                     
            MobileNo,                     
            Message,                     
            ContactPersonName,                    
            TypeofEstablishment,                     
            DirectorsName,                     
            CompanyRegistrationNumber,                    
            Address,                     
            City,                     
            State,                     
            PinCode,              
            Country,              
            PanCardNo,              
            CreatedDate,            
            CountryCode,     
            Source ,  
   SalesPerCode         
        )                     
        VALUES (                    
            @InquiryGuid,                     
            @AgencyName,                     
            @EmailID,                     
            @MobileNo,                     
            @Message,                     
            @ContactPersonName,                    
            @TypeofEstablishment,                     
            @DirectorsName,                     
            @CompanyRegistrationNumber,                    
            @Address,                     
            @City,                     
            @State,                     
            @PinCode,                  
            @CountryCode,                
            @PanCardNo,              
            GETDATE(),            
            @CountryCode,      
            'TrvlNxt' ,  
      Null  
           );      
                                      
        SET @Result = 1;                         
    END                        
END 