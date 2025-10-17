CREATE TABLE [dbo].[ss.SS_UserCancelledTicket_Data] (
    [Id]           INT          NOT NULL,
    [PkId]         NCHAR (10)   NULL,
    [CancelFlag]   BIT          NULL,
    [InsertedDate] DATETIME     NULL,
    [BookingRefId] VARCHAR (50) NULL,
    [MethodName]   VARCHAR (50) NULL
);

