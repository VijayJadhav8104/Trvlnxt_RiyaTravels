CREATE TABLE [dbo].[APIUrlList] (
    [Id]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [APIUrl]   VARCHAR (255) NOT NULL,
    [IsActive] BIT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

