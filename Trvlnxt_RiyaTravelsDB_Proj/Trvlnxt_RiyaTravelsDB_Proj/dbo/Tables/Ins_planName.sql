CREATE TABLE [dbo].[Ins_planName] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [planID]      INT           NOT NULL,
    [planName]    VARCHAR (100) NULL,
    [planType]    VARCHAR (10)  NULL,
    [updatedDate] DATETIME      NULL,
    [InsurerName] VARCHAR (100) NOT NULL
);

