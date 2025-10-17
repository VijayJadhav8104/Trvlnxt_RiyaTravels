CREATE TABLE [Hotel].[Agentbalance_StatusLog] (
    [Pkid]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKtransactionID] INT           NULL,
    [BookingStatus]   VARCHAR (200) NULL,
    [CreatedDate]     DATETIME      CONSTRAINT [DF_Agentbalance_StatusLog_CreatedDate] DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Noncluster_composite_index]
    ON [Hotel].[Agentbalance_StatusLog]([FKtransactionID] ASC)
    INCLUDE([BookingStatus]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_comp_index_1]
    ON [Hotel].[Agentbalance_StatusLog]([FKtransactionID] ASC)
    INCLUDE([BookingStatus]);

