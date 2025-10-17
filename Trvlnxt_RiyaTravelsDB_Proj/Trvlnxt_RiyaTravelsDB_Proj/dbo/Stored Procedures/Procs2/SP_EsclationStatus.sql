CREATE Proc SP_EsclationStatus      
      
@Id int=0,      
@Desposition varchar(200)='',      
@Resolution varchar(200)='',      
 @ModifiedBy int=0      
as      
begin      
Update Hotel_BookMaster set DispositionStatus=@Desposition,ResolutionStatus=@Resolution      
where pkId=@Id     
  
insert into Hotel_UpdatedHistory           
  (fkbookid,FieldName ,FieldValue,InsertedDate,InsertedBy,UpdatedType)          
 values (@Id,'Esclation Status',@Desposition +','+@Resolution,GETDATE(),@ModifiedBy,'Esclation')            
      SELECT SCOPE_IDENTITY();    
end 


--select DespositionStatus,ResolutionStatus,* from Hotel_BookMaster where pkid=185497