create PROCEDURE [dbo].[UpdateHoldTimelimitdetailsOneapi]      --  '2E3GK6',0,'RITK/ADTKT BY 25FEB 2039 DXB LT','01/01/0001 00:00:00' 
  @GDSPNR varchar(10),          
  @Holdflag bit,          
  @HoldText varchar(max),  
  @HoldDate varchar(100)      
            
AS          
BEGIN          
  UPDATE tblBookMaster         
  SET HoldText=@HoldText,        
  HoldTimeLimitflag=1,
  HoldDate=@HoldDate        
  where riyaPNR=@GDSPNR          
END 