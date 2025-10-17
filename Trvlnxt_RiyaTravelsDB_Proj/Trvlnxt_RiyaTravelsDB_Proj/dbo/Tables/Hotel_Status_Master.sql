CREATE TABLE [dbo].[Hotel_Status_Master] (
    [Id]     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Status] VARCHAR (200) NULL,
    CONSTRAINT [PK_Hotel_Status_Master] PRIMARY KEY CLUSTERED ([Id] ASC)
);

