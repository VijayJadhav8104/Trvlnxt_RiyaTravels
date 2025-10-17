CREATE TABLE [SS].[SS_QuestionAnswer] (
    [QuestionAnswerID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActivityId]       INT          NULL,
    [BookingId]        INT          NULL,
    [PaxID]            INT          NULL,
    [label]            VARCHAR (50) NULL,
    [questionCode]     VARCHAR (50) NULL,
    [answer]           VARCHAR (50) NULL,
    [unit]             VARCHAR (50) NULL,
    CONSTRAINT [PK_SS_QuestionAnswer] PRIMARY KEY CLUSTERED ([QuestionAnswerID] ASC)
);

