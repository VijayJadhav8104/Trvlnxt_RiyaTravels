CREATE TABLE [Invoice].[Outstanding_WY] (
    [Id]           BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Code]         VARCHAR (50)    NULL,
    [Outstanding]  DECIMAL (18, 2) NULL,
    [CreatedDate]  DATETIME        CONSTRAINT [DF_Outstanding_WY_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedDate] DATETIME        NULL,
    [Closing]      DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_Outstanding_WY] PRIMARY KEY CLUSTERED ([Id] ASC)
);

