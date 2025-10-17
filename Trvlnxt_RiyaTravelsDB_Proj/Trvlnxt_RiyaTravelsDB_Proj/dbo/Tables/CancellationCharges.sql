CREATE TABLE [dbo].[CancellationCharges] (
    [Pk_Id]                  BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirCode]                VARCHAR (20) NULL,
    [amount]                 INT          NULL,
    [insert_date]            DATE         NULL,
    [userId]                 INT          NULL,
    [modifiedDate]           DATE         NULL,
    [status]                 VARCHAR (5)  CONSTRAINT [DF_CancellationCharges_status] DEFAULT ('A') NULL,
    [ModifiedBy]             INT          NULL,
    [CancellationChargeType] INT          NULL,
    PRIMARY KEY CLUSTERED ([Pk_Id] ASC)
);

