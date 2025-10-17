CREATE TABLE [dbo].[mROEHistoryAir] (
    [HistoryId]    INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fromCountry]  VARCHAR (10)     NULL,
    [ToCountry]    VARCHAR (10)     NULL,
    [OldROE]       DECIMAL (18, 10) NULL,
    [NewROE]       DECIMAL (18, 10) NULL,
    [ROEId]        INT              NULL,
    [Request]      VARCHAR (50)     NULL,
    [Response]     VARCHAR (MAX)    NULL,
    [InsertedDate] DATE             CONSTRAINT [DF_mROEHistoryAir_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_mROEHistoryAir] PRIMARY KEY CLUSTERED ([HistoryId] ASC)
);

