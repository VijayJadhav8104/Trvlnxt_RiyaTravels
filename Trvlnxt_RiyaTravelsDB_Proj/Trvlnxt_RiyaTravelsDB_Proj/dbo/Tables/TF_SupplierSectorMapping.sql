CREATE TABLE [dbo].[TF_SupplierSectorMapping] (
    [PkId]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierId]   BIGINT        NOT NULL,
    [SupplierName] VARCHAR (500) NULL,
    [Sector]       VARCHAR (500) NOT NULL,
    [Inserted_On]  DATETIME      CONSTRAINT [DF_TF_SupplierSectorMapping_Inserted_On] DEFAULT (getdate()) NOT NULL,
    [Status]       BIT           CONSTRAINT [DF_TF_SupplierSectorMapping_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TF_SupplierSectorMapping] PRIMARY KEY CLUSTERED ([PkId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250620-112225]
    ON [dbo].[TF_SupplierSectorMapping]([SupplierId] ASC, [Sector] ASC)
    INCLUDE([SupplierName]) WITH (FILLFACTOR = 95);

