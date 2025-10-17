CREATE TABLE [dbo].[FidoStoredCredential] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [UserName]       NVARCHAR (100) NOT NULL,
    [RegDate]        DATETIME       NOT NULL,
    [DeviceId]       NVARCHAR (100) NOT NULL,
    [DescriptorJson] NVARCHAR (MAX) NOT NULL,
    [UserId]         INT            NOT NULL,
    [RegistrationId] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_FidoStoredCredential] PRIMARY KEY CLUSTERED ([Id] ASC)
);

