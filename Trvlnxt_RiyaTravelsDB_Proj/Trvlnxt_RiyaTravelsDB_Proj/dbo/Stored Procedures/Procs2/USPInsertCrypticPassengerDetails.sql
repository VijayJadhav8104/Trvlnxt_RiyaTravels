-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[USPInsertCrypticPassengerDetails]  
@PAXType varchar(10)=null,
@FirstName VARCHAR(50)=NULL,  
@LastName  VARCHAR(50)=NULL,  
@Title VARCHAR(10)=NULL,  
@FlightNo VARCHAR(10)=NULL,  
@CabinClass VARCHAR(50)=NULL,  
@DepartureDateTime DATE=NULL,  
@AirCode VARCHAR(10)=NULL,  
@FromLocation VARCHAR(50)=NULL,  
@Tolocation VARCHAR(50)=NULL,  
@GDSPNR VARCHAR(50)=NULL,  
@AgentId VARCHAR(50)=NULL,  
@OfficeID VARCHAR(50)=NULL  
AS  
BEGIN  
if not exists(select * from tblCrypticPassengerdata where PAXFirstName=@FirstName and PAXLastName=@LastName and GDSPNR=@GDSPNR)
begin
  INSERT INTO tblCrypticPassengerdata  
  (Title,  
  PAXFirstName,  
  PAXLastName,  
  FlightNo,  
  CabinClass,  
  DeptureDate,  
  AirCode,  
  FromSector,  
  ToSector,  
  GDSPNR,  
  AgentId,  
  OfficeID,
  PAXType)  
  
  VALUES(  
  @Title,  
  @FirstName,  
  @LastName,  
  @FlightNo,  
  @CabinClass,  
  @DepartureDateTime,  
  @AirCode,  
  @FromLocation,  
  @Tolocation,  
  @GDSPNR,  
  @AgentId,  
  @OfficeID,
  @PAXType)  
  end
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPInsertCrypticPassengerDetails] TO [rt_read]
    AS [dbo];

