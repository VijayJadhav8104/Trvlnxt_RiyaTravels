CREATE TABLE [dbo].[FlightSearchLog] (
    [LogIDP]     BIGINT          IDENTITY (1, 1) NOT NULL,
    [CacheKey]   VARCHAR (500)   NULL,
    [LogData]    VARBINARY (MAX) NULL,
    [DepDate]    DATETIME        NULL,
    [TravelFrom] VARCHAR (10)    NULL,
    [TravelTo]   VARCHAR (10)    NULL,
    [FromIndex]  INT             NULL,
    [ToIndex]    INT             NULL,
    [APIName]    VARCHAR (50)    NULL,
    [LogDate]    DATETIME        CONSTRAINT [DF_FlightSearchLog_LogDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_FlightSearchLog] PRIMARY KEY CLUSTERED ([LogIDP] ASC)
);

