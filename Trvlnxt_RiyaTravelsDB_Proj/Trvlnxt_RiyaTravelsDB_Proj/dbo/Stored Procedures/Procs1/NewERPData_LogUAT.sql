-- =============================================
-- Author:		Rahul Agrahari
-- Create date: 17/01/2022
-- Description:	<Description,,>
-- =====================================
CREATE PROCEDURE [dbo].[NewERPData_LogUAT]
	@FK_tblPassengerBDId bigint =null,
	@Action varchar(200) =null,
	@Type varchar(100) =null,	
	@ERPRequest varchar(Max)=null,
	@ERPResponse varchar(Max) =null
AS
BEGIN
		SET NOCOUNT ON;
		--Select top 10 * from NewERPData_Log where type='DBException' order by id desc
		If @Type='DBException' And @FK_tblPassengerBDId=0
			Begin
			Update UATNewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE() 
				where FK_tblbookmasterID=@FK_tblPassengerBDId;
				Select @FK_tblPassengerBDId;
			End
		Else
			Begin
				If EXISTS(Select 1 from UATNewERPData_Log Where FK_tblbookmasterID=@FK_tblPassengerBDId)
					Begin
						Update UATNewERPData_Log set Type=@Type, Response=@ERPResponse,Request=@ERPRequest,CreatedOn=GETDATE() 
						where FK_tblbookmasterID=@FK_tblPassengerBDId;
						Select @FK_tblPassengerBDId;
					End
				Else
					Begin
						insert into UATNewERPData_Log(FK_tblbookmasterID,Type,Request,Response,CreatedOn) values(@FK_tblPassengerBDId,@Type,
						@ERPRequest,@ERPResponse,GETDATE());
						Select @FK_tblPassengerBDId;
					End    	
			End
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[NewERPData_LogUAT] TO [rt_read]
    AS [dbo];

