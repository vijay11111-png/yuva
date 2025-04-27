import js from "@eslint/js";
import globals from "globals";
import parser from "@typescript-eslint/parser"; // Import parser directly
import plugin from "@typescript-eslint/eslint-plugin"; // Import plugin directly
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs,ts}"],
    languageOptions: {
      globals: globals.node,
      ecmaVersion: "latest",
      sourceType: "module",
      parser: parser, // Use the imported parser
    },
    plugins: {
      "@typescript-eslint": plugin, // Use the imported plugin
    },
    extends: [
      js.configs.recommended,
    ],
    rules: {
      "eol-last": "off",              // Disable eol-last rule
      "no-unused-vars": "off",        // Disable general no-unused-vars
      "no-undef": "off",              // Disable no-undef to ignore undefined variables like onRequest
      "@typescript-eslint/no-unused-vars": "off", // Disable TypeScript-specific no-unused-vars
    },
  },
]);