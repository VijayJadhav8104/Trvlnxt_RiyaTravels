CREATE PROC DeleteOfficeID   
 @ID INT    
AS    
BEGIN    
 delete from tbl_commonmaster Where Mapping=@ID     
END