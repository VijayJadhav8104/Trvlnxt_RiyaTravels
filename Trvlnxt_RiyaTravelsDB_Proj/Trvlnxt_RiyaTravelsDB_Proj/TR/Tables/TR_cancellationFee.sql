CREATE TABLE [TR].[TR_cancellationFee] (
    [CancellationFeeId]             INT          IDENTITY (1, 1) NOT NULL,
    [BookingId]                     INT          NOT NULL,
    [description]                   VARCHAR (50) NULL,
    [cancelIfBadWeather]            INT          NULL,
    [cancelIfInsufficientTravelers] INT          NULL,
    CONSTRAINT [PK_TR_cancellationFee] PRIMARY KEY CLUSTERED ([CancellationFeeId] ASC)
);

