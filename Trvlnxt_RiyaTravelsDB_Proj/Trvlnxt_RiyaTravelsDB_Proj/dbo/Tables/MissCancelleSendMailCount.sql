CREATE TABLE [dbo].[MissCancelleSendMailCount] (
    [id]                     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingPkid]            INT           NULL,
    [MissBookingReferenceid] VARCHAR (100) NULL,
    [InsertedDate]           DATETIME      NULL,
    CONSTRAINT [PK_MissCancelleSendMailCount] PRIMARY KEY CLUSTERED ([id] ASC)
);

