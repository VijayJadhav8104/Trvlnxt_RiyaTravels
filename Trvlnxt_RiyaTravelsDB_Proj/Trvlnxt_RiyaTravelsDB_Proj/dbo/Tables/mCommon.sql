CREATE TABLE [dbo].[mCommon] (
    [ID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category] VARCHAR (50) NULL,
    [Value]    VARCHAR (50) NULL,
    [OfficeID] VARCHAR (50) NULL,
    CONSTRAINT [PK_mCommon] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [mCommon_Value]
    ON [dbo].[mCommon]([Value] ASC);

