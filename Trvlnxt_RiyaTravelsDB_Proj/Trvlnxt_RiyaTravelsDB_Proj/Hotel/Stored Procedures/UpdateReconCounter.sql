          
     --- created on 25 feb 2025 : To maintain api call of particular booking counter --     
Create Proc Hotel.UpdateReconCounter          
          
@Id int=0,
@counter int=0
as           
          
begin          
          
BEGIN TRANSACTION [Tran1]          
          
  BEGIN TRY          
          
Update Hotel_BookMaster        
set ReconCounter=@counter                 
where pkId=@Id          
          
COMMIT TRANSACTION [Tran1]          
          
  END TRY          
          
  BEGIN CATCH          
          
      ROLLBACK TRANSACTION [Tran1]          
          
  END CATCH            
          
end           
          
