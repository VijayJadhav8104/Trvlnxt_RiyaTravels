CREATE TABLE [dbo].[Hotel_City_Master] (
    [ID]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CityName]         NVARCHAR (255) NULL,
    [CityCode]         NVARCHAR (100) NULL,
    [CountryID]        NVARCHAR (100) NULL,
    [CountryName]      VARCHAR (MAX)  NULL,
    [RealCityName]     NVARCHAR (255) NULL,
    [CityCode_i2space] VARCHAR (50)   NULL,
    CONSTRAINT [PK_Hotel_City_Master] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_CityCode]
    ON [dbo].[Hotel_City_Master]([CityCode] ASC);

