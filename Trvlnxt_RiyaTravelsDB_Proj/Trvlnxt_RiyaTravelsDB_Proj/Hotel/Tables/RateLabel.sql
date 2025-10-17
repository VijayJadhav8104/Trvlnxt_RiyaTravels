CREATE TABLE [Hotel].[RateLabel] (
    [Id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Rate]       VARCHAR (255) NULL,
    [Label]      VARCHAR (255) NULL,
    [Category_N] NVARCHAR (10) NULL,
    [Category_P] NVARCHAR (10) NULL,
    [Category_B] NVARCHAR (10) NULL,
    [AgentId]    INT           NULL,
    [SupplierId] INT           NULL,
    [CreatedBy]  INT           NULL,
    [CreatedOn]  DATETIME      CONSTRAINT [DF_RateLabel_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK__RateLabe__3214EC07D0214C43] PRIMARY KEY CLUSTERED ([Id] ASC)
);

