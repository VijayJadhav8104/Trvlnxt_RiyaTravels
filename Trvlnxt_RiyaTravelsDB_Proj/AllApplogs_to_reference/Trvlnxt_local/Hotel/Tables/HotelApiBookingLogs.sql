CREATE TABLE [Hotel].[HotelApiBookingLogs] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [BookingId]     VARCHAR (50)  NULL,
    [CorrelationId] VARCHAR (150) NULL,
    [AgentId]       VARCHAR (50)  NULL,
    [Timmer]        VARCHAR (150) NULL,
    [Header]        VARCHAR (MAX) NULL,
    [Request]       VARCHAR (MAX) NULL,
    [Response]      VARCHAR (MAX) NULL,
    [URL]           VARCHAR (200) NULL,
    [InsertedDate]  DATETIME      CONSTRAINT [DF_HotelApiBookingLogs_InsertedDate] DEFAULT (getdate()) NULL,
    [IP]            VARCHAR (100) NULL,
    [Token]         VARCHAR (500) NULL,
    [BookingPortal] VARCHAR (50)  NULL,
    CONSTRAINT [PK_HotelApiBookingLogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-correlationID]
    ON [Hotel].[HotelApiBookingLogs]([CorrelationId] ASC, [ID] ASC) WITH (FILLFACTOR = 95);

