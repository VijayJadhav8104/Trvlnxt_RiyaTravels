  
CREATE PROCEDURE GetPnrStatus  
(    
      @GDSPNR VARCHAR(100)    
)    
AS    
--DECLARE @ResultValue VARCHAR(100) = null     
BEGIN   
--set @ResultValue = (  

select BookingStatus from tblBookMaster where GDSPNR = @GDSPNR

--declare @BookStatus int = null

--set @BookStatus  = (select BookingStatus from tblBookMaster where GDSPNR = @GDSPNR)  

--if	(@BookStatus is null)
--BEGIN
--	set @BookStatus = (select BookingStatus from tblBookMaster tbm inner join tblBookItenary tbi on tbm.pkId=tbi.fkBookMaster where airlinePNR = @GDSPNR)
--END

--select @BookStatus BookingStatus
--)  
  
END  
--RETURN @ResultValue   
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPnrStatus] TO [rt_read]
    AS [dbo];

