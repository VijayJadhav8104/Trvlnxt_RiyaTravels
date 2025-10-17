CREATE TABLE [SS].[SS_CancellationFeeDetail] (
    [PKId]              INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CancellationFeeId] INT          NOT NULL,
    [BookingPkId]       INT          NULL,
    [valueType]         VARCHAR (50) NULL,
    [Value]             FLOAT (53)   NULL,
    [estimatedValue]    FLOAT (53)   NULL,
    [startDate]         DATETIME     NULL,
    [endDate]           DATETIME     NULL,
    CONSTRAINT [PK_SS_CancellationFeeDetail] PRIMARY KEY CLUSTERED ([PKId] ASC)
);

