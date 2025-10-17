CREATE TABLE [dbo].[ROE] (
    [Id]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromCur]    NVARCHAR (500) NULL,
    [ToCur]      NVARCHAR (500) NULL,
    [ROE]        FLOAT (53)     NULL,
    [Commission] FLOAT (53)     NULL,
    [InserDate]  DATETIME       NULL,
    [IsActive]   BIT            NULL,
    CONSTRAINT [PK_ROE] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_composite]
    ON [dbo].[ROE]([IsActive] ASC)
    INCLUDE([FromCur], [ToCur], [ROE], [Commission], [InserDate]);

