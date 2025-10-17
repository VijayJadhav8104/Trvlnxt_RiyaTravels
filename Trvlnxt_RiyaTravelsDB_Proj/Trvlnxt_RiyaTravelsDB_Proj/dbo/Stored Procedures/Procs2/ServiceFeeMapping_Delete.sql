create proc [dbo].[ServiceFeeMapping_Delete]
@Id int
As
Begin
	  delete from tblAgentServiceFeeMapping where Id=@Id

END