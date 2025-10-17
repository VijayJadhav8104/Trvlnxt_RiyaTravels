CREATE TABLE [dbo].[APIBookingAuthentication_Internal] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [APIBookingRefID] BIGINT        NULL,
    [SellKey]         VARCHAR (MAX) NULL,
    [FlightKey]       VARCHAR (MAX) NULL,
    [SessionToken]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK_APIBookingAuthentication_Internal] PRIMARY KEY CLUSTERED ([Id] ASC)
);

