CREATE TABLE [dbo].[mAgentGSTMapping] (
    [ID]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]            INT           NOT NULL,
    [DisplayText]        VARCHAR (50)  NULL,
    [RegistrationNumber] VARCHAR (50)  NULL,
    [CompanyName]        VARCHAR (50)  NULL,
    [CompanyAddress]     VARCHAR (MAX) NULL,
    [State]              INT           NULL,
    [ContactNo]          VARCHAR (20)  NULL,
    [Email]              VARCHAR (50)  NULL,
    [IsEditable]         BIT           CONSTRAINT [DF_mAgentGSTMapping_IsEditable] DEFAULT ((0)) NOT NULL,
    [CreatedBy]          INT           NOT NULL,
    [CreatedOn]          DATETIME      CONSTRAINT [DF_mAgentGSTMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_mAgentGSTMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

