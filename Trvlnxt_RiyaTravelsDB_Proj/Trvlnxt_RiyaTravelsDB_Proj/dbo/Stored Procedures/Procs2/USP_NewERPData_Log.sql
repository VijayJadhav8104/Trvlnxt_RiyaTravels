-- =============================================  
-- Author:  Rahul Agrahari  
-- Create date: 17/01/2022  
-- Description: <Description,,>  
-- =====================================  
CREATE PROCEDURE [dbo].[USP_NewERPData_Log]  
 @FK_tblPassengerBDId bigint =null,  
 @Action varchar(200) =null,  
 @Type varchar(100) =null,   
 @ERPRequest varchar(Max)=null,  
 @ERPResponse varchar(Max) =null  
AS  
BEGIN  
  SET NOCOUNT ON;  
  --Select top 10 * from NewERPData_Log where type='DBException' order by id desc  
  if @Action = '' or @Action is null  
  If @Type='DBException' And @FK_tblPassengerBDId=0  
   Begin  
   Update NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()   
    where FK_tblbookmasterID=@FK_tblPassengerBDId and  Type=@Type;  
    Select @FK_tblPassengerBDId;  
   End  
  Else  
   Begin  
    If EXISTS(Select 1 from NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId and Type=@Type )  
     Begin  
      Update NewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE()   
      where FK_tblbookmasterID=@FK_tblPassengerBDId and  Type=@Type ;
      Select @FK_tblPassengerBDId;  
     End  
    Else  
     Begin  
      insert into NewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,  
      @ERPRequest,@ERPResponse,GETDATE());  
      Select @FK_tblPassengerBDId;  
     End       
   End  
  
  if @Action='payment'  
   If @Type='DBException' And @FK_tblPassengerBDId=0  
   Begin  
   Update NewERPData_Log set PaymentType=@Type, PaymentResponse=@ERPResponse,PaymentRequest=@ERPRequest,CreatedOn=GETDATE()   
    where FK_tblbookmasterID=@FK_tblPassengerBDId;  
    Select @FK_tblPassengerBDId;  
   End  
  Else  
   Begin  
    If EXISTS(Select 1 from NewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)  
     Begin  
      Update NewERPData_Log set PaymentType=@Type, PaymentResponse=@ERPResponse,PaymentRequest=@ERPRequest,CreatedOn=GETDATE()   
      where FK_tblbookmasterID=@FK_tblPassengerBDId;  
      Select @FK_tblPassengerBDId;  
     End  
  
    Else  
     Begin  
      insert into NewERPData_Log(FK_tblbookmasterID,PaymentType,PaymentRequest,PaymentResponse,CreatedOn) values(@FK_tblPassengerBDId,@Type,  
      @ERPRequest,@ERPResponse,GETDATE());  
      Select @FK_tblPassengerBDId;  
     End       
   End  
  
  if @Action='InCompany'  
   If @Type='DBException' And @FK_tblPassengerBDId=0  
   Begin  
   Update INCERPdataLog set Type=@Type, Response=@ERPResponse,Request=@ERPRequest   
    where fkBookMasterId=@FK_tblPassengerBDId;  
    Select @FK_tblPassengerBDId;  
   End  
  Else  
   Begin  
    If EXISTS(Select 1 from INCERPdataLog Where fkBookMasterId=@FK_tblPassengerBDId)  
     Begin  
      Update INCERPdataLog set Type=@Type, Response=@ERPResponse,Request=@ERPRequest   
      where fkBookMasterId=@FK_tblPassengerBDId;  
      Select @FK_tblPassengerBDId;  
     End  
    Else  
     Begin  
      insert into INCERPdataLog(fkBookMasterId,Type,Request,Response) values(@FK_tblPassengerBDId,@Type,  
      @ERPRequest,@ERPResponse);  
      Select @FK_tblPassengerBDId;  
     End       
   End  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_NewERPData_Log] TO [rt_read]
    AS [dbo];

