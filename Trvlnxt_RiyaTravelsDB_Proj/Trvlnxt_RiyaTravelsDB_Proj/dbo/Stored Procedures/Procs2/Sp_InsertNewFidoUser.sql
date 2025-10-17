create procedure [dbo].[Sp_InsertNewFidoUser]

@UserName nvarchar(100),
@UserId int = 0,
@DeviceId nvarchar(100) = '',
@DescriptorJson nvarchar(MAX) = '',
@RegistrationId nvarchar(100) = '',
@RegDate datetime

As
Begin
 Insert Into FidoStoredCredential (UserName, [UserId], DeviceId, DescriptorJson, RegistrationId, RegDate) 
		Values(@UserName, @UserId, @DeviceId, @DescriptorJson, @RegistrationId, @RegDate)
End