  
CREATE PROCEDURE updatePKFGDSPNR   
 @OrderNum varchar (50),  
 @GDSPNR varchar (30)  
  
AS  
BEGIN  
   
 update tblBookMaster set GDSPNR=@GDSPNR,IsBooked=1 where PKForderNum=@OrderNum  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[updatePKFGDSPNR] TO [rt_read]
    AS [dbo];

