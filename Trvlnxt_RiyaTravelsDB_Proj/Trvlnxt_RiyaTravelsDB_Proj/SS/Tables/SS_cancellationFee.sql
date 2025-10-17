CREATE TABLE [SS].[SS_cancellationFee] (
    [CancellationFeeId]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]                     INT           NOT NULL,
    [description]                   VARCHAR (MAX) NULL,
    [cancelIfBadWeather]            INT           NULL,
    [cancelIfInsufficientTravelers] INT           NULL,
    CONSTRAINT [PK_SS_cancellationFee] PRIMARY KEY CLUSTERED ([CancellationFeeId] ASC)
);

