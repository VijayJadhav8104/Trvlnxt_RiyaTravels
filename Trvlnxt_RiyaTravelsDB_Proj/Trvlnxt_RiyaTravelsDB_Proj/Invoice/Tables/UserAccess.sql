CREATE TABLE [Invoice].[UserAccess] (
    [Id]     BIGINT       IDENTITY (1, 1) NOT NULL,
    [UserId] BIGINT       NULL,
    [Role]   INT          NULL,
    [Module] VARCHAR (50) NULL,
    CONSTRAINT [PK_UserAccess] PRIMARY KEY CLUSTERED ([Id] ASC)
);

