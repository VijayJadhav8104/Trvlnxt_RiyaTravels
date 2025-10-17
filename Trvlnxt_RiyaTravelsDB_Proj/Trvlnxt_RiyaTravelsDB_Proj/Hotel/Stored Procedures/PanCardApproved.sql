  
CREATE Procedure [Hotel].[PanCardApproved]  
@Pkid int,  
@PanCardName varchar(500),  
@PancardStatus varchar(100),  
@PanCardNo  varchar(500),  
@ModifiedBy int  
as  
  
begin  
  
if(@PancardStatus='Approved')  
  
Begin  
  
  begin
Update Hotel_BookMaster  set CorporatePANVerificatioStatus=@PancardStatus  Where pkId=@Pkid  
  end
  begin
Update Hotel_Pax_master set Pancard=@PanCardNo,PanCardName=@PanCardName where book_fk_id=@Pkid and IsLeadPax=1  
  end
  begin
insert into Hotel_UpdatedHistory (fkbookid,FieldName,FieldValue,InsertedDate,InsertedBy,UpdatedType)  
Values (@Pkid,'Corporate_Pan_Verification',@PanCardName+','+@PanCardNo,GETDATE(),@ModifiedBy,'PanVerification')  
  end
End  
  
else if (@PancardStatus='Rejected')  
begin  
  
Update Hotel_BookMaster  set CorporatePANVerificatioStatus=@PancardStatus  Where pkId=@Pkid  
  
  
insert into Hotel_UpdatedHistory (fkbookid,FieldName,FieldValue,InsertedDate,InsertedBy,UpdatedType)  
Values (@Pkid,'Corporate_Pan_Verification',@PanCardName+','+@PanCardNo,GETDATE(),@ModifiedBy,'PanVerification')  
  
end  
  
End  
  
  