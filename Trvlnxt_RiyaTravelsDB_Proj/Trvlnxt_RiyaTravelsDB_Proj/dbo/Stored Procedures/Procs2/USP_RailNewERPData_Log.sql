CREATE PROCEDURE [dbo].[USP_RailNewERPData_Log]            
 @FK_tblPassengerBDId bigint =null,            
 @Action varchar(200) =null,            
 @Type varchar(100) =null,             
 @ERPRequest varchar(Max)=null,            
 @ERPResponse varchar(Max) =null            
AS       
DECLARE @BookingsFessID INT;    
BEGIN      
    
  SET NOCOUNT ON;       
      
  --Select top 10 * from NewERPData_Log where type='DBException' order by id desc      
   if @Action = 'Exception'             
  If @Type='DBException' And @FK_tblPassengerBDId=0            
   Begin            
   Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
    where FK_tblbookmasterID=@FK_tblPassengerBDId;            
    Select @FK_tblPassengerBDId;            
   End            
  Else            
   Begin            
    If EXISTS(Select 1 from Rail_NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)            
     Begin            
      Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
      where FK_tblbookmasterID=@FK_tblPassengerBDId;            
      Select @FK_tblPassengerBDId;            
     End            
    Else            
     Begin            
      insert into Rail_NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,            
      @ERPRequest,@ERPResponse,GETDATE());            
      Select @FK_tblPassengerBDId;            
     End                 
   End       
 if @Action = 'Success'            
  If @Type='CreateWOIns' And @FK_tblPassengerBDId=0            
   Begin            
   Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
    where FK_tblbookmasterID=@FK_tblPassengerBDId;            
    Select @FK_tblPassengerBDId;            
   End            
  Else            
   Begin            
    If EXISTS(Select 1 from Rail_NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)            
     Begin            
      Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
      where FK_tblbookmasterID=@FK_tblPassengerBDId;            
      Select @FK_tblPassengerBDId;            
     End            
    Else            
     Begin            
      insert into Rail_NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,            
      @ERPRequest,@ERPResponse,GETDATE());            
      Select @FK_tblPassengerBDId;            
     End                 
   End            
    if @Action = 'Error'           
  If @Type='Error-CreateWOIns' And @FK_tblPassengerBDId=0            
   Begin            
   Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
    where FK_tblbookmasterID=@FK_tblPassengerBDId;            
    Select @FK_tblPassengerBDId;            
   End            
  Else            
   Begin            
    If EXISTS(Select 1 from Rail_NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)            
     Begin            
      Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
      where FK_tblbookmasterID=@FK_tblPassengerBDId;            
      Select @FK_tblPassengerBDId;            
     End            
    Else            
     Begin            
      insert into Rail_NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,            
      @ERPRequest,@ERPResponse,GETDATE());            
      Select @FK_tblPassengerBDId;            
     End                 
   End   
    if @Action = 'Success_US_CA_UK'            
  If @Type='CreateWOIns_US_CA_UK' And @FK_tblPassengerBDId=0            
   Begin            
   Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
    where FK_tblbookmasterID=@FK_tblPassengerBDId;            
    Select @FK_tblPassengerBDId;            
   End            
  Else            
   Begin            
    If EXISTS(Select 1 from Rail_NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)            
     Begin            
      Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
      where FK_tblbookmasterID=@FK_tblPassengerBDId;            
      Select @FK_tblPassengerBDId;            
     End            
    Else            
     Begin            
      insert into Rail_NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,            
      @ERPRequest,@ERPResponse,GETDATE());            
      Select @FK_tblPassengerBDId;            
     End                 
   End   
 if @Action = 'NavNotAccepted'             
  If @Type='False-CreateWOIns' And @FK_tblPassengerBDId=0            
   Begin            
   Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()          
    where FK_tblbookmasterID=@FK_tblPassengerBDId;            
    Select @FK_tblPassengerBDId;            
   End            
  Else            
   Begin            
    If EXISTS(Select 1 from Rail_NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)            
     Begin            
      Update Rail_NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()             
      where FK_tblbookmasterID=@FK_tblPassengerBDId;            
      Select @FK_tblPassengerBDId;            
     End            
    Else            
     Begin            
      insert into Rail_NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,            
      @ERPRequest,@ERPResponse,GETDATE());            
      Select @FK_tblPassengerBDId;            
     End                 
   End        
    if @Action = 'BookingFeesSuccess'            
  If @Type='BookingFees'         
   Begin            
   SELECT TOP 1 @BookingsFessID = ISNULL(FK_tblbookmasterID, 0)
    FROM Rail_NewERPData_Log
    WHERE Type = 'BookingFees'
    ORDER BY CreatedOn DESC; 
    SET @BookingsFessID = @BookingsFessID + 1;
    INSERT INTO Rail_NewERPData_Log (FK_tblbookmasterID, Type, Request, Response, CreatedOn)
    VALUES (@BookingsFessID, @Type, @ERPRequest, @ERPResponse, GETDATE());
    SELECT @FK_tblPassengerBDId; 
 End    
   if @Action = 'BookingFeesSuccess_US_CA_UK'            
  If @Type='BookingFees_US_CA_UK'         
   Begin            
   SELECT TOP 1 @BookingsFessID = ISNULL(FK_tblbookmasterID, 0)
    FROM Rail_NewERPData_Log
    WHERE Type = 'BookingFees_US_CA_UK'
    ORDER BY CreatedOn DESC; 
    SET @BookingsFessID = @BookingsFessID + 1;
    INSERT INTO Rail_NewERPData_Log (FK_tblbookmasterID, Type, Request, Response, CreatedOn)
    VALUES (@BookingsFessID, @Type, @ERPRequest, @ERPResponse, GETDATE());
    SELECT @FK_tblPassengerBDId; 
 End      
END 