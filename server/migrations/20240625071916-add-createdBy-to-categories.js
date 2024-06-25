"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn("Categories", "createdBy", {
      type: Sequelize.STRING,
      allowNull: false,
      defaultValue: "system", // Default value to avoid issues with existing records
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn("Categories", "createdBy");
  },
};
