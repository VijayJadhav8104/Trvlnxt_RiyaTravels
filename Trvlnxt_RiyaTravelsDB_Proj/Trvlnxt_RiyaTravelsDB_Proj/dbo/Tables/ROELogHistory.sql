CREATE TABLE [dbo].[ROELogHistory] (
    [Id]           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromCurrency] VARCHAR (10) NULL,
    [ToCurrency]   VARCHAR (10) NULL,
    [Products]     VARCHAR (50) NULL,
    [UserType]     INT          NULL,
    [MarkupType]   VARCHAR (50) NULL,
    [MarkupData]   FLOAT (53)   NULL,
    [InsertedDate] DATETIME     NULL,
    [InsertedBy]   VARCHAR (50) NULL,
    CONSTRAINT [PK_ROELogHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

