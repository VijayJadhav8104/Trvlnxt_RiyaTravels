-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE SS.Sightseeing_SBReversalStatusUpdate    
     
 @Id int=0,    
 @BookingRefrence varchar(200)    
AS    
BEGIN    
     
 update SS.SS_BookingMaster set ReversalStatus=1     
 where BookingId=@Id     
 and BookingRefId=@BookingRefrence    
    
END 