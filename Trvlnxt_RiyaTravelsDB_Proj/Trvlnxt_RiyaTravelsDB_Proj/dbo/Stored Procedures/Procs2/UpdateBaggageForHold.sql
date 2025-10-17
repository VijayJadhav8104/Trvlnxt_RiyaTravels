CREATE PROCEDURE [dbo].[UpdateBaggageForHold] 
@PaxId      int, 
@baggage varchar(300)=null              
                    
AS                     
BEGIN

UPDATE tblPassengerBookDetails SET     baggage = case when @baggage is not null AND @baggage <> '' then @baggage else baggage end   WHERE pid = @PaxId       

END 