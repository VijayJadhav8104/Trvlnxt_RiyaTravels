CREATE TABLE [Rail].[BookingSectors] (
    [Id]               BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_bookingitemId] BIGINT        NULL,
    [Origin]           VARCHAR (500) NULL,
    [Destination]      VARCHAR (500) NULL,
    [Departure]        SMALLDATETIME NULL,
    [Arrival]          SMALLDATETIME NULL,
    [Duration]         VARCHAR (100) NULL,
    [SequenceNumber]   INT           NULL,
    [isRoundTrip]      BIT           NULL,
    [isInBound]        BIT           NULL,
    [CreatedDate]      DATETIME      CONSTRAINT [DF_BookingSectors_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedDate]     DATETIME      NULL,
    CONSTRAINT [PK_BookingSectors] PRIMARY KEY CLUSTERED ([Id] ASC)
);

