CREATE TABLE [Invoice].[PushLog] (
    [ID]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [Request]     VARCHAR (MAX) NULL,
    [Response]    VARCHAR (MAX) NULL,
    [Module]      VARCHAR (50)  NULL,
    [CreatedBy]   VARCHAR (50)  NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_PushLog_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_PushLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

