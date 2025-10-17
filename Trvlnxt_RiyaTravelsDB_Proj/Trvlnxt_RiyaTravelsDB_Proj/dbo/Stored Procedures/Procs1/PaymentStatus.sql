CREATE Proc PaymentStatus    
    
@Id int=0,    
@Remark varchar(200)='',    
@Status varchar(200)='' ,
@UserId int=0
    
as    
begin    
Update Hotel_BookMaster set PaymentRemark=@Remark,PaymentStatus=@Status    
where pkId=@Id 

begin

insert into Hotel_UpdatedHistory (fkbookid,FieldValue,FieldName,InsertedBy,InsertedDate,UpdatedType)
values (@Id,@Status+','+@Remark,'PaymentStatus',@UserId,GETDATE(),'PaymentStatus')
end

end