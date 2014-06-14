CREATE TABLE [dbo].[Product] (
    [ProductID]      INT            IDENTITY (1, 1) NOT NULL,
    [Description]    NVARCHAR (500) NOT NULL,
    [ProductGroupID] INT            NULL,
    [Version]        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_Product_ProductGroup] FOREIGN KEY ([ProductGroupID]) REFERENCES [dbo].[ProductGroup] ([ProductGroupID])
);



