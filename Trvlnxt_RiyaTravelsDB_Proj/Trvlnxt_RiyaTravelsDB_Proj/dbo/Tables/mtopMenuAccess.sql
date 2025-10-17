CREATE TABLE [dbo].[mtopMenuAccess] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [AgentID]   INT           NULL,
    [MenuName]  VARCHAR (50)  NULL,
    [Menulink]  VARCHAR (500) NULL,
    [Isstaff]   BIT           CONSTRAINT [DF_mtopMenuAccess_Isstaff] DEFAULT ((0)) NULL,
    [Module]    VARCHAR (50)  NULL,
    [CreatedOn] DATETIME      CONSTRAINT [DF_mtopMenuAccess_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedBy] BIGINT        NULL,
    CONSTRAINT [PK_MtopMenuAccess] PRIMARY KEY CLUSTERED ([ID] ASC)
);

