CREATE TABLE [dbo].[tblStateCode] (
    [Id]           INT          NOT NULL,
    [StateCode]    VARCHAR (50) NULL,
    [State]        VARCHAR (50) NULL,
    [StateGSTCode] BIGINT       NULL,
    CONSTRAINT [PK_tblStateCode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

