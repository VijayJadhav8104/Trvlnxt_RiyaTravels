CREATE TABLE [dbo].[mActionAccess] (
    [ID]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActionName]      VARCHAR (100) NULL,
    [MenuID]          INT           NULL,
    [isActive]        BIT           DEFAULT ((1)) NOT NULL,
    [ActionControlID] VARCHAR (100) NULL,
    [IsColumn]        BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

