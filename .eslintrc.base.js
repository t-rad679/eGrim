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
        "object-curly-spacing": [
            "error",
            "always",
        ],
        "@stylistic/ts/comma-dangle": [
            "error",
            "always-multiline",
        ],
    },
}

module.exports = config