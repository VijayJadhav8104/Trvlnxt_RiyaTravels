CREATE TABLE [dbo].[CrypticCommand] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CommandRequest]  VARCHAR (200)  NULL,
    [CommandResponse] NVARCHAR (MAX) NULL,
    [PNRNumber]       VARCHAR (6)    NULL,
    [CreatedOn]       DATETIME       CONSTRAINT [DF_CrypticCommand_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]       INT            NULL,
    [CRS]             VARCHAR (15)   NULL,
    [LastCmd]         VARCHAR (50)   NULL,
    [MainAgentID]     VARCHAR (50)   NULL,
    [OfficeID]        VARCHAR (50)   NULL,
    [SessionID]       VARCHAR (255)  NULL,
    CONSTRAINT [PK_CrypticCommand] PRIMARY KEY CLUSTERED ([Id] ASC)
);

