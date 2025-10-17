CREATE TABLE [dbo].[tblEntityMaster] (
    [Pkid]          INT           IDENTITY (1, 1) NOT NULL,
    [EntityName]    VARCHAR (MAX) NULL,
    [BillingEntity] VARCHAR (MAX) NULL,
    [BillingID]     VARCHAR (MAX) NULL,
    [CreatedBy]     INT           NULL,
    [CreatedDate]   DATETIME      CONSTRAINT [DF_tblEntityMaster_CreatedDate] DEFAULT (getdate()) NULL,
    [UpdatedDate]   DATE          NULL,
    [UpdatedBy]     INT           NULL,
    [IsActive]      BIT           NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

