const config= {
    env: {
        es2021: true,
        node: true,
    },
    extends: [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:import/recommended",
        "plugin:import/typescript",
    ],
    settings: {
        "import/resolver": {
            typescript: true,
            node: true,
        },
    },
    parserOptions: {
        ecmaVersion: "latest",
        parser: "@typescript-eslint/parser",
    },
    plugins: [
        "@typescript-eslint",
        "@stylistic/ts",
        "import-newlines",
        "unused-imports",
    ],
    rules: {
        indent: [
            "error",
            4,
        ],
        "linebreak-style": [
            "error",
            "unix",
        ],
        quotes: [
            "error",
            "double",
        ],
        semi: [
            "error",
            "never",
        ],
        "sort-imports": [
            "error",
            {
                ignoreDeclarationSort: true,
            },
        ],
        "import/order": [
            "error",
            {
                alphabetize: {
                    order: "asc",
                    caseInsensitive: false,
                },
                groups: [
                    "builtin",
                    "external",
                    "internal",
                    "unknown",
                    "parent",
                    "sibling",
                    "index",
                    "object",
                    "type",
                ],
                "newlines-between": "always",
            },
        ],
        "import-newlines/enforce": [
            "error",
            {
                items: 1,
                "max-len": 120,
                semi: false,
            },
        ],
        "object-curly-spacing": [
            "error",
            "always",
        ],
        "unused-imports/no-unused-imports": "error",
        "@stylistic/ts/comma-dangle": [
            "error",
            "always-multiline",
        ],
        "@typescript-eslint/no-unused-vars": [
            "error",
            {
                "argsIgnorePattern": "^_",
                "varsIgnorePattern": "^_",
            }
        ]
    },
}

module.exports = config