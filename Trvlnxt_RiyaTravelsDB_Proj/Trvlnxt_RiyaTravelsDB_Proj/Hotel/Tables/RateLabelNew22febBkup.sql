CREATE TABLE [Hotel].[RateLabelNew22febBkup] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Rate]       VARCHAR (255) NULL,
    [Label]      VARCHAR (255) NULL,
    [Category_N] NVARCHAR (10) NULL,
    [Category_P] NVARCHAR (10) NULL,
    [Category_B] NVARCHAR (10) NULL,
    [AgentId]    INT           NULL,
    [SupplierId] INT           NULL,
    [isActive]   BIT           NULL,
    [CreatedBy]  INT           NULL,
    [CreatedOn]  DATETIME      NULL
);

