create proc [dbo].[Hotel_ServiceFeeMapping_Delete]
@Id int
As
Begin
	  DELETE FROM [Hotel_AgentServiceFeeMapping] where ID=@Id
END