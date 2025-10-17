CREATE PROCEDURE [dbo].[UpdateGDSPNR_InternationalReturn]        
@OrderId   varchar(30),        
@GDSPNR    varchar(8)        
AS BEGIN        
        
 UPDATE tblBookMaster SET GDSPNR = @GDSPNR         
 --WHERE orderId = @OrderId  AND airCode NOT IN ('SG','6E','G8')        
 --WHERE orderId = @OrderId  AND airCode NOT IN ('SG','G8')      
 WHERE orderId = @OrderId  --AND airCode NOT IN ('G8')      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGDSPNR_InternationalReturn] TO [rt_read]
    AS [dbo];

