CREATE TABLE [dbo].[AmadeusBookingLog] (
    [Id]           BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AmadeusPNR]   VARCHAR (50)   NULL,
    [AmadeusCity]  VARCHAR (500)  NULL,
    [CheckInDate]  DATETIME       NULL,
    [CheckOutDate] DATETIME       NULL,
    [PaxName]      VARCHAR (500)  NULL,
    [Request]      NVARCHAR (MAX) NULL,
    [Response]     NVARCHAR (MAX) NULL,
    [SessionId]    VARCHAR (100)  NULL,
    [CreatedBy]    INT            NULL,
    [CreatedOn]    DATETIME       CONSTRAINT [DF_AmadeusBookingLog_CreatedOn] DEFAULT (getdate()) NULL,
    [MethodName]   VARCHAR (100)  NULL,
    CONSTRAINT [PK_AmadeusBookingLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

