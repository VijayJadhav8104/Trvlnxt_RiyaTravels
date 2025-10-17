CREATE TABLE [dbo].[GescoMarineDSR] (
    [ID]        INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DATE]      DATE     NULL,
    [Status]    BIT      NULL,
    [createdOn] DATETIME NULL,
    CONSTRAINT [PK_GescoMarineDSR] PRIMARY KEY CLUSTERED ([ID] ASC)
);

