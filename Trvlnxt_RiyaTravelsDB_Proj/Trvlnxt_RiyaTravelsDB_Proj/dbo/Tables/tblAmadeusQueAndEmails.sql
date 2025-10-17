CREATE TABLE [dbo].[tblAmadeusQueAndEmails] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GDSPNR]       VARCHAR (50)  NULL,
    [BookingId]    VARCHAR (10)  NULL,
    [OfficeId]     VARCHAR (50)  NULL,
    [QueueNo]      VARCHAR (50)  NULL,
    [Emails]       VARCHAR (MAX) NULL,
    [OTP]          VARCHAR (50)  NULL,
    [orderId]      VARCHAR (50)  NULL,
    [IsQueued]     BIT           NULL,
    [IsPNRUpdated] BIT           NULL,
    CONSTRAINT [PK_tblAmadeusQueAndEmails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

