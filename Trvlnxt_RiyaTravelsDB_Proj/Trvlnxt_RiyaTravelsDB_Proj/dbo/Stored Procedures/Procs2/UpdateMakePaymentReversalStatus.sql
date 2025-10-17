-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE UpdateMakePaymentReversalStatus  
   
 @PkId int=0,  
 @Book_Id varchar(500)=null,  
 @status varchar(200)=null,  
 @StatusFlag varchar(200)=null,  
 @msg varchar(max)=null  
  
   
AS  
BEGIN  
   
  
 update Hotel_BookMaster set MakePaymentReversalFlag=@status ,   
        MakePaymentReversalStatus=@StatusFlag,  
        MakePaymentReversalMessage=@msg  
  
 where pkId=@PkId  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateMakePaymentReversalStatus] TO [rt_read]
    AS [dbo];

