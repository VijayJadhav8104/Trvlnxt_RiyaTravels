
create procedure [dbo].[Sp_GetExistingFidoUser]

@UserName nvarchar(100)

As
Begin
	Select * From FidoStoredCredential Where UserName = @UserName
End