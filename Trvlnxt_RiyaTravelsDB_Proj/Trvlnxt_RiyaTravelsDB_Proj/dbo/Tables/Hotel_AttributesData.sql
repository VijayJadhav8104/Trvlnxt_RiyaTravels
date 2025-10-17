CREATE TABLE [dbo].[Hotel_AttributesData] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [FKBookId]        INT           NULL,
    [AttributeId]     INT           NULL,
    [Attributes]      VARCHAR (200) NULL,
    [AttributesValue] VARCHAR (200) NULL
);

