CREATE TABLE [dbo].[markUpMaster] (
    [Pk_Id]        BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirCode]      VARCHAR (20) NULL,
    [ChargeType]   VARCHAR (50) NULL,
    [amount]       INT          NULL,
    [insert_date]  DATE         NULL,
    [userId]       INT          NULL,
    [modifiedDate] DATE         NULL,
    [Status]       VARCHAR (5)  CONSTRAINT [DF_markUpMaster_Status] DEFAULT ('A') NULL,
    [ModifiedBy]   INT          NULL,
    CONSTRAINT [PK_markUpMaster] PRIMARY KEY CLUSTERED ([Pk_Id] ASC)
);

