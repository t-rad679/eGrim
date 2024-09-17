export function createFieldRequiredRule(fieldName: string) {
    return (value: string) => (!!value || `${fieldName} is required`)
}