CREATE TABLE [dbo].[ProductProperty] (
    [ProductPropertyID]      INT             IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT             NOT NULL,
    [ProductGroupPropertyID] INT             NOT NULL,
    [Value]                  NVARCHAR (1000) NULL,
    [Version]                ROWVERSION      NOT NULL,
    CONSTRAINT [PK_ProductProperty] PRIMARY KEY CLUSTERED ([ProductPropertyID] ASC),
    CONSTRAINT [FK_ProductProperty_Product1] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]),
    CONSTRAINT [FK_ProductProperty_ProductGroupProperty] FOREIGN KEY ([ProductGroupPropertyID]) REFERENCES [dbo].[ProductGroupProperty] ([ProductGroupPropertyID])
);



