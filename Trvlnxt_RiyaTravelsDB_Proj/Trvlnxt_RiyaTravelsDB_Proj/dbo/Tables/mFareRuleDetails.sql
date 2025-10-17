CREATE TABLE [dbo].[mFareRuleDetails] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [FareID]      INT           NOT NULL,
    [Header]      VARCHAR (500) NULL,
    [Description] VARCHAR (MAX) NULL,
    [CreatedOn]   DATETIME      NULL,
    [CreatedBy]   INT           NULL,
    [ModifiedBy]  INT           NULL,
    [ModifiedOn]  DATETIME      NULL,
    CONSTRAINT [PK_mFareRuleDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);

