CREATE TABLE [dbo].[mAgentROE] (
    [ID]          INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]    VARCHAR (10)     NULL,
    [Country]     VARCHAR (10)     NULL,
    [AgencyID]    VARCHAR (MAX)    NULL,
    [AgencyNames] VARCHAR (MAX)    NULL,
    [Currency]    VARCHAR (10)     NULL,
    [ROE]         DECIMAL (18, 16) NULL,
    [CreatedBy]   INT              NOT NULL,
    [CreatedOn]   DATETIME2 (7)    CONSTRAINT [DF_mAgentROE_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedOn]  DATETIME2 (7)    NULL,
    [ModifiedBy]  INT              NULL,
    [IsActive]    BIT              CONSTRAINT [DF_mAgentROE_IsActive] DEFAULT ((1)) NOT NULL,
    [IsDeleted]   BIT              CONSTRAINT [DF_mAgentROE_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_mAgentROE] PRIMARY KEY CLUSTERED ([ID] ASC)
);

