CREATE TABLE [dbo].[Marine_TJQ_PNRRetriveLogsAir] (
    [LogId]        INT           IDENTITY (1, 1) NOT NULL,
    [GDSPNR]       VARCHAR (20)  NULL,
    [MethodName]   VARCHAR (200) NULL,
    [Request]      VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME2 (7) NULL,
    CONSTRAINT [PK_Marine_TJQ_PNRRetriveLogsAir] PRIMARY KEY CLUSTERED ([LogId] ASC)
);

