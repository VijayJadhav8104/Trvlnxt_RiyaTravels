CREATE TABLE [Rail].[IsConfirmed] (
    [Id]        BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId] VARCHAR (100) NULL,
    [TimeStamp] DATETIME      NULL,
    CONSTRAINT [PK_IsConfirmed] PRIMARY KEY CLUSTERED ([Id] ASC)
);

