    
      
Create Procedure [TR].[TR_PanCardApproved]      
@Pkid int,      
@PanCardName varchar(500),      
@PancardStatus varchar(100),      
@PanCardNo  varchar(500),      
@ModifiedBy int      
as      
      
begin      
  if(@PancardStatus='Approved')    
  begin    
Update TR.TR_BookingMaster  set CorporatePANVerificatioStatus=@PancardStatus  Where BookingId=@Pkid      
      
Update TR.TR_PaxDetails set PancardNo=@PanCardNo,PanCardName=@PanCardName where BookingId=@Pkid --and IsLeadPax=1      
      
insert into TR.TR_bookingUpdate_History(fkbookid,FieldName,FieldValue,InsertedDate,InsertedBy,UpdatedType)      
Values (@Pkid,'Corporate_Pan_Verification',@PanCardName+','+@PanCardNo,GETDATE(),@ModifiedBy,'PanVerification')      
      
 end     
    
 else if(@PancardStatus='Rejected')    
    
 begin    
 Update TR.TR_BookingMaster  set CorporatePANVerificatioStatus=@PancardStatus  Where BookingId=@Pkid     
    
  insert into TR.TR_bookingUpdate_History (fkbookid,FieldName,FieldValue,InsertedDate,InsertedBy,UpdatedType)      
Values (@Pkid,'Corporate_Pan_Verification',@PanCardName+','+@PanCardNo,GETDATE(),@ModifiedBy,'PanVerification')    
    
end    
    
End      