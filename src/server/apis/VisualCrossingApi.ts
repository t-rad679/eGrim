import { Location } from "@prisma/client"
import axios, { AxiosResponse } from "axios"

type VisualCrossingApiResponseData = {
    // In the Visual Crossing API, moonphase is only reported at the day level.
    // There are many more fields here, but this is the only one we care about.
    days: {
        moonphase: number,
    }[],
}

export async function getMoonPhaseForDateTime(dateTime: Date, location: Location): Promise<number> {
    const dateString = `${dateTime.getFullYear()}-${dateTime.getMonth()}-${dateTime.getDay()-2}`
    const locationString = `${location.city},${location.state},${location.country}`
    const result: AxiosResponse<VisualCrossingApiResponseData> = await axios.get(
        `${process.env.VISUAL_CROSSING_DOMAIN}/${locationString}/${dateString}?key=${process.env.VISUAL_CROSSING_API_KEY}&elements=moonphase`,
    )
    return result.data.days[0].moonphase
}
