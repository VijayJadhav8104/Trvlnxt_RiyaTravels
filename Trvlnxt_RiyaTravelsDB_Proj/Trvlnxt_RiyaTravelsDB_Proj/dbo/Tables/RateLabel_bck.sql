CREATE TABLE [dbo].[RateLabel_bck] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Rate]       VARCHAR (255) NULL,
    [Label]      VARCHAR (255) NULL,
    [Category_N] INT           NULL,
    [Category_P] INT           NULL,
    [Category_B] INT           NULL,
    [AgentId]    INT           NULL,
    [SupplierId] INT           NULL,
    [CreatedBy]  INT           NULL,
    [CreatedOn]  DATETIME      NULL
);

