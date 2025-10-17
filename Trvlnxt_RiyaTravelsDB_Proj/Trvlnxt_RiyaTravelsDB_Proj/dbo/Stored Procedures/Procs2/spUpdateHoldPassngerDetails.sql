   --exec spUpdateHoldPassngerDetails 402614, 'efxdsd'
CREATE proc [dbo].[spUpdateHoldPassngerDetails]      
  @PaxId int     
 ,@PancardNo varchar(250)=null  
 ,@PancardValidation varchar(250)=null  
 
AS      
BEGIN      
   
 Update tblPassengerBookDetails set PanNumber=@PancardNo,PancardValidation=@PancardValidation
   WHERE pid = @PaxId    
    
END      
      
      
                 
      