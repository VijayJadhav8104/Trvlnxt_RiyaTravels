CREATE TABLE [dbo].[PNRRetriveLogsAir] (
    [LogId]        INT           IDENTITY (1, 1) NOT NULL,
    [GDSPNR]       VARCHAR (50)  NULL,
    [MethodName]   VARCHAR (MAX) NULL,
    [Request]      VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_PNRRetriveLogsAir_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_PNRRetriveLogsAir] PRIMARY KEY CLUSTERED ([LogId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-GDSPNR]
    ON [dbo].[PNRRetriveLogsAir]([GDSPNR] ASC);

