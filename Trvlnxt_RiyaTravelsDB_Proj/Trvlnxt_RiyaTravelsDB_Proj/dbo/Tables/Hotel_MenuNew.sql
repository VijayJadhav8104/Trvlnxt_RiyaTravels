CREATE TABLE [dbo].[Hotel_MenuNew] (
    [Id]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Action]     VARCHAR (50) NULL,
    [Controller] VARCHAR (50) NULL,
    [Title]      VARCHAR (50) NULL,
    [UserId]     VARCHAR (50) NULL,
    CONSTRAINT [PK_Hotel_MenuNew] PRIMARY KEY CLUSTERED ([Id] ASC)
);

