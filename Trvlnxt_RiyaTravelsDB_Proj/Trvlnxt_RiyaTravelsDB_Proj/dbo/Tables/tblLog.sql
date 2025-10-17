CREATE TABLE [dbo].[tblLog] (
    [Title]      VARCHAR (MAX) NULL,
    [Detail]     VARCHAR (MAX) NULL,
    [InsertedOn] DATETIME      DEFAULT (getdate()) NULL
);

