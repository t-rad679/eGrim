// This exists for images, which are not supported yet
export function chunkArray(inputArray: string[], chunkSize: number): string[][] {
    const result: string[][] = []

    for (let i = 0; i < inputArray.length; i += chunkSize) {
        const chunk = inputArray.slice(i, i + chunkSize)
        result.push(chunk)
    }

    return result
}
