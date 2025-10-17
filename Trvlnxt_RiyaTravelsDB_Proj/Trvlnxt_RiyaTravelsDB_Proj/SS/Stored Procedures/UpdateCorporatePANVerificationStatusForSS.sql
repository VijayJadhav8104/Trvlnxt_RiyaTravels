CREATE procedure [SS].[UpdateCorporatePANVerificationStatusForSS]    
@BookingRefId varchar(100),  
@filePath  varchar(1000)=''  
As    
Begin    
 Update SS.SS_BookingMaster Set CorporatePANVerificatioStatus='Pending',DocumentURL=@filePath Where BookingRefId=@BookingRefId    
 Select BookingId from SS.SS_BookingMaster Where BookingRefId=@BookingRefId    
End