CREATE procedure UpdateCorporatePANVerificationStatus  
@BookingReference varchar(100),
@filePath  varchar(1000)=''
As  
Begin  
 Update Hotel_BookMaster Set CorporatePANVerificatioStatus='Pending',PanCardURL=@filePath Where BookingReference=@BookingReference  
 Select PKId from Hotel_BookMaster Where BookingReference=@BookingReference  
End