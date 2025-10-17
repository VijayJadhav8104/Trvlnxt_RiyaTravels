create proc [dbo].[Transfer_ServiceFeeMapping_Delete]  
@Id int  
As  
Begin  
   DELETE FROM [Transfer_AgentServiceFeeMapping] where ID=@Id  
END