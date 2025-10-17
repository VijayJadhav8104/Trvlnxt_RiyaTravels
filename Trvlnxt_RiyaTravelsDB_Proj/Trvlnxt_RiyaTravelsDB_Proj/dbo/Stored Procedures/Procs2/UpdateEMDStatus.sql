CREATE PROCEDURE UpdateEMDStatus  
    @FK_tblPassengerBDId INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    UPDATE tblpassengerbookdetails  
    SET EMDstatus = 1  
    WHERE pid = @FK_tblPassengerBDId;  
END;