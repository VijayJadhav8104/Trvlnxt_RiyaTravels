        
        
CREATE Proc Hotel.Sp_UpdateReConfirmation        
        
@Id int=0,        
@HotelConfirmationRemarks varchar(500)='',        
--@ChkPaxConfirmation bit=0,      
--@ChkRoomConfirmation bit=0,      
--@ChkMealConfirmation bit=0,      
@ModifiedBy int=0        
        
        
as         
        
begin        
        
BEGIN TRANSACTION [Tran1]        
        
  BEGIN TRY        
        
Update Hotel_BookMaster      
set  
--PassangerReConfirmation=@ChkPaxConfirmation,      
--RoomReConfirmation=@ChkRoomConfirmation,      
--MealReConfirmation=@ChkMealConfirmation,      
PassengerDetailsReconfirmationRemark=@HotelConfirmationRemarks ,        
      
PassengerDetailsReconfirmationBy=@ModifiedBy        
where pkId=@Id        
        
        
insert into Hotel_UpdatedHistory(fkbookid,FieldName,FieldValue,InsertedBy,InsertedDate,UpdatedType)        
 values  (@Id,'Passenger Details ReConfirmation',@HotelConfirmationRemarks,@ModifiedBy,GETDATE(),'Passenger Details ReConfirmation')        
        
COMMIT TRANSACTION [Tran1]        
        
  END TRY        
        
  BEGIN CATCH        
        
      ROLLBACK TRANSACTION [Tran1]        
        
  END CATCH          
        
end         
        
--select * from hotedupdatedhistory order by 1 desc