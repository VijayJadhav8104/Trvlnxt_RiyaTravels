CREATE TABLE [dbo].[tbl_marinepromodetails] (
    [PromoID]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgencyCustID]    VARCHAR (100) NULL,
    [MarinePromoCode] VARCHAR (50)  NULL,
    [IsActive]        BIT           NULL,
    [AgentId]         VARCHAR (MAX) NULL,
    [Carrier]         VARCHAR (20)  NULL,
    [OfficeId]        VARCHAR (50)  NULL,
    CONSTRAINT [PK_tbl_marinepromodetails] PRIMARY KEY CLUSTERED ([PromoID] ASC)
);

