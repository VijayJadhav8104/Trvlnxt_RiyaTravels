CREATE TABLE [dbo].[ROE_Temp01] (
    [Id]        INT             NOT NULL,
    [FromCur]   NVARCHAR (500)  NULL,
    [ToCur]     NVARCHAR (500)  NULL,
    [ROE]       DECIMAL (18, 8) NULL,
    [InserDate] DATETIME        NULL,
    [IsActive]  BIT             NULL
);

