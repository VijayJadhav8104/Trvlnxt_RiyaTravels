CREATE TABLE [Rail].[BookingStatusHistory] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [Fk_BookingId]  BIGINT        NULL,
    [BookingStatus] VARCHAR (100) NULL,
    [CreatedDate]   DATETIME      CONSTRAINT [DF_BookingStatusHistory_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_BookingStatusHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

