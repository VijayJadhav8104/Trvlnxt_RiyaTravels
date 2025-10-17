-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [TR].[Transfer_SBReversalStatusUpdate]        
         
 @Id int=0,        
 @BookingRefrence varchar(200)        
AS        
BEGIN        
         
 update TR.TR_BookingMaster set ReversalStatus=1         
 where BookingId=@Id         
 and BookingRefId=@BookingRefrence        
        
END 