CREATE PROCEDURE SPCrypticCommandCRUD  
 @CommandRequest varchar(200)=null,  
 @CommandResponse varchar(max)=null,  
 @CreatedBy int=null,  
 @PNRNumber varchar(6)=null,  
 @CRS varchar(15)=null,  
 @LastCmd varchar(15)=null,
 @MainAgentID varchar(15) = null,
 @officeid varchar(50)=null,
 @sessionid varchar(50)=null
AS  
BEGIN  
  
 INSERT INTO CrypticCommand(CommandRequest,CommandResponse,PNRNumber,CreatedOn,CreatedBy,CRS,LastCmd,MainAgentID,OfficeID,SessionID)  
 VALUES (@CommandRequest,@CommandResponse,@PNRNumber,GETDATE(),@CreatedBy,@CRS,@LastCmd,@MainAgentID,@officeid,@sessionid)  
  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SPCrypticCommandCRUD] TO [rt_read]
    AS [dbo];

