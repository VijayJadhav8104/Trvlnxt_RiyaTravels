CREATE TABLE [dbo].[TJQ_IATA_exempt_ICUST] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [CustID]       VARCHAR (255) NULL,
    [IsActive]     BIT           NULL,
    [InsertedDate] DATETIME      NULL,
    CONSTRAINT [PK_TJQ_IATA_exempt_ICUST] PRIMARY KEY CLUSTERED ([Id] ASC)
);

