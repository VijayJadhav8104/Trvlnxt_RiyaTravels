CREATE TABLE [dbo].[tblBookingLogsAir] (
    [LogId]        INT           NULL,
    [MethodName]   VARCHAR (MAX) NULL,
    [AirlineName]  VARCHAR (10)  NULL,
    [SessionId]    VARCHAR (200) NULL,
    [GDSPNR]       VARCHAR (50)  NULL,
    [Request]      VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [Inserteddate] DATETIME      NULL,
    [DepDate]      VARCHAR (50)  NULL
);

