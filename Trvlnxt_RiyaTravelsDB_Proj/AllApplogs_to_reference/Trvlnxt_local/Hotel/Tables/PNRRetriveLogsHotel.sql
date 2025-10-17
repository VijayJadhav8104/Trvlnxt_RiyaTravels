CREATE TABLE [Hotel].[PNRRetriveLogsHotel] (
    [id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [pnr]        NVARCHAR (50)  NULL,
    [MethodName] NVARCHAR (100) NULL,
    [request]    NVARCHAR (MAX) NULL,
    [response]   NVARCHAR (MAX) NULL,
    [CreatedOn]  DATETIME       CONSTRAINT [DF_PNRRetriveLogsAirHotel_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_HotelPNRLogs] PRIMARY KEY CLUSTERED ([id] ASC)
);

