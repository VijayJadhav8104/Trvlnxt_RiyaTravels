CREATE TABLE [dbo].[AmadeusErrorLog] (
    [Record_id]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [startTime]   VARCHAR (20)  NULL,
    [queCount]    INT           NULL,
    [pnrInserted] INT           NULL,
    [endTime]     VARCHAR (20)  NULL,
    [errMsg]      INT           NULL,
    [stackTrace]  VARCHAR (MAX) NULL,
    [unqPNR]      INT           NULL,
    CONSTRAINT [PK_AmadeusErrorLog] PRIMARY KEY CLUSTERED ([Record_id] ASC)
);

