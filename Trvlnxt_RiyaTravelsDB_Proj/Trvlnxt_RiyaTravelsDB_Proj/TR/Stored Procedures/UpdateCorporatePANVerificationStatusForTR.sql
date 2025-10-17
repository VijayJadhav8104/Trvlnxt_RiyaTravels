CREATE procedure [TR].[UpdateCorporatePANVerificationStatusForTR]        
@BookingRefId varchar(100),      
@filePath  varchar(1000)=''      
As        
Begin        
 Update TR.TR_BookingMaster Set CorporatePANVerificatioStatus='Pending',DocumentURL=@filePath Where BookingRefId=@BookingRefId        
 Select BookingId from TR.TR_BookingMaster Where BookingRefId=@BookingRefId        
End