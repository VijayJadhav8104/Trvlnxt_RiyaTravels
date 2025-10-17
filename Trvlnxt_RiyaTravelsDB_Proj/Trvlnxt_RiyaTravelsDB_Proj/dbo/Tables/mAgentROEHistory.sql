CREATE TABLE [dbo].[mAgentROEHistory] (
    [HId]         INT              IDENTITY (1, 1) NOT NULL,
    [ROEId]       INT              NULL,
    [UserType]    VARCHAR (50)     NULL,
    [Coutry]      VARCHAR (50)     NULL,
    [AgencyID]    VARCHAR (MAX)    NULL,
    [Currency]    VARCHAR (10)     NULL,
    [ROE]         DECIMAL (18, 16) NULL,
    [ResponseGDS] VARCHAR (MAX)    NULL,
    [CommandName] VARCHAR (MAX)    NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_mAgentROEHistory] PRIMARY KEY CLUSTERED ([HId] ASC)
);

