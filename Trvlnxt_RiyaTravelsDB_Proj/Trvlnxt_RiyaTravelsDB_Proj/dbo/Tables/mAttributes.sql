CREATE TABLE [dbo].[mAttributes] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Attributes]     VARCHAR (MAX) NOT NULL,
    [Value]          VARCHAR (60)  NULL,
    [SequenceOrder]  INT           NULL,
    [AttrSeqOrderBy] INT           NULL,
    CONSTRAINT [PK_mAttributes] PRIMARY KEY CLUSTERED ([ID] ASC)
);

