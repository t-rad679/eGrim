// This exists for images, which are not supported yet
export async function validateImageUrl(url: string): Promise<string> {
    let errorMessage: string = ""
    try {
        const response = await fetch(url, { method: "HEAD" })
        const contentType = response.headers.get("Content-Type")
        errorMessage = contentType && contentType.startsWith("image/") ? "" : "URL does not point to an image"
    } catch (error) {
        errorMessage = "Error validating image URL"
    }
    return errorMessage
}
