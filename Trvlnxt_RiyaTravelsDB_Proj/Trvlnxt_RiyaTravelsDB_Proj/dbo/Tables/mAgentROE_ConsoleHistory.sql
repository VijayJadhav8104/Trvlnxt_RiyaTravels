CREATE TABLE [dbo].[mAgentROE_ConsoleHistory] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Action]      VARCHAR (50)     NULL,
    [UserType]    VARCHAR (10)     NULL,
    [Country]     VARCHAR (10)     NULL,
    [AgencyID]    VARCHAR (MAX)    NULL,
    [AgencyNames] VARCHAR (MAX)    NULL,
    [Currency]    VARCHAR (10)     NULL,
    [ROE]         DECIMAL (18, 16) NULL,
    [CreatedBy]   INT              NOT NULL,
    [CreatedOn]   DATETIME2 (7)    CONSTRAINT [DF_mAgentROE_ConsoleHistory_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF_mAgentROE_ConsoleHistory_IsActive] DEFAULT ((1)) NOT NULL,
    [IsDeleted]   BIT              CONSTRAINT [DF_mAgentROE_ConsoleHistory_IsDeleted] DEFAULT ((0)) NOT NULL
);

