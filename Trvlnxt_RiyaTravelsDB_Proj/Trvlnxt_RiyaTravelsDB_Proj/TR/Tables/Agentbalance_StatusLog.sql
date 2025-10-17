CREATE TABLE [TR].[Agentbalance_StatusLog] (
    [Pkid]            INT           IDENTITY (1, 1) NOT NULL,
    [FKtransactionID] INT           NULL,
    [BookingStatus]   VARCHAR (200) NULL,
    [CreatedDate]     DATETIME      NULL
);

