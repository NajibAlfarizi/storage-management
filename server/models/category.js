"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Category extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Category.hasMany(models.Product, {
        foreignKey: "categoryId",
        as: "products",
      });
    }
  }
  Category.init(
    {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      createdBy: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "system", // Set a default value to avoid issues with existing records
      },
    },
    {
      sequelize,
      modelName: "Category",
    }
  );
  return Category;
};
