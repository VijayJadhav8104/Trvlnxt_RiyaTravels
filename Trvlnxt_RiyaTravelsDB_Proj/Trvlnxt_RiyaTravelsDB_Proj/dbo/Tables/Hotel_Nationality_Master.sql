CREATE TABLE [dbo].[Hotel_Nationality_Master] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Code]        VARCHAR (50) NULL,
    [Nationality] VARCHAR (50) NULL,
    [ISOCode]     VARCHAR (50) NULL,
    CONSTRAINT [PK_Hotel_Nationality_Master] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230713-174728]
    ON [dbo].[Hotel_Nationality_Master]([ISOCode] ASC);

