CREATE TABLE [Hotel].[mAttributes_Hotel] (
    [ID]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Attributes]     NVARCHAR (MAX) NOT NULL,
    [Value]          VARCHAR (500)  NULL,
    [SequenceOrder]  INT            NULL,
    [AttrSeqOrderBy] INT            NULL,
    [IsActive]       BIT            NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

