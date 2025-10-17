CREATE TABLE [dbo].[Ins_planDetails] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [planID]      INT           NOT NULL,
    [planName]    VARCHAR (100) NULL,
    [areaName]    VARCHAR (50)  NULL,
    [minDays]     VARCHAR (35)  NULL,
    [maxDays]     VARCHAR (35)  NULL,
    [minAge]      VARCHAR (35)  NULL,
    [maxAge]      VARCHAR (35)  NULL,
    [benefits]    VARCHAR (MAX) NULL,
    [deductible]  VARCHAR (100) NULL,
    [limits]      VARCHAR (100) NULL,
    [updatedDate] DATETIME      NULL,
    [insurerName] VARCHAR (50)  NULL
);

