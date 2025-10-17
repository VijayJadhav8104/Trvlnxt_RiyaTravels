CREATE TABLE [dbo].[FlightFlat_Delete] (
    [ID]                INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FlatID]            INT             NULL,
    [MarketPoint]       VARCHAR (30)    NULL,
    [AirportType]       VARCHAR (50)    NULL,
    [AirlineType]       VARCHAR (50)    NULL,
    [PaxType]           VARCHAR (50)    NULL,
    [Remark]            VARCHAR (MAX)   NULL,
    [Min]               NUMERIC (18, 2) NULL,
    [Max]               NUMERIC (18, 2) NULL,
    [Discount]          NUMERIC (18, 2) NULL,
    [InsertedDate]      DATETIME        NULL,
    [DeletedBy]         VARCHAR (50)    NULL,
    [DeletedDate]       DATETIME        NULL,
    [Origin]            BIT             NULL,
    [OriginValue]       VARCHAR (MAX)   NULL,
    [Destination]       BIT             NULL,
    [DestinationValue]  VARCHAR (MAX)   NULL,
    [Flightseries]      BIT             NULL,
    [FlightseriesValue] VARCHAR (MAX)   NULL,
    [cabin]             VARCHAR (50)    NULL,
    CONSTRAINT [PK_FlightFlat_Delete] PRIMARY KEY CLUSTERED ([ID] ASC)
);

