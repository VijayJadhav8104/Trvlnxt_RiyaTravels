CREATE TABLE [dbo].[Hotel_UpdatedHistory] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkbookid]     INT           NULL,
    [FieldName]    VARCHAR (500) NULL,
    [FieldValue]   VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME      NULL,
    [InsertedBy]   INT           NULL,
    [UpdatedType]  VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_fkbookid]
    ON [dbo].[Hotel_UpdatedHistory]([fkbookid] ASC);

