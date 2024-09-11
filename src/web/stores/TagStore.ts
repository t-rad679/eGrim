import { useMutation, useQuery } from "@vue/apollo-composable"
import gql from "graphql-tag"
import { defineStore } from "pinia"
import { onBeforeMount, ref, watch } from "vue"

import { useUserStore } from "./UserStore"

const fetchTagsQueryText = gql`
    query fetchTags($userId: String!) {
        tags(where: { userId: { equals: $userId } }) {
            id
            name
        }
    }
`

const createTagsQueryText = gql`
    mutation createTag($input: [TagCreateManyInput!]!) {
        createManyTag(data: $input) {
            count
        }
    }
`

export const useTagStore = defineStore("tag", () => {
    const userStore = useUserStore()
    const tags = ref([])
    const error = ref(null)

    const { refetch, result: queryResult, error: queryError } = useQuery(fetchTagsQueryText, {
        userId: userStore.user.id,
    })

    const fetchTags = async (): Promise<void> => {
        watch(queryResult, (newResult) => {
            if (newResult && newResult.tags) {
                tags.value = newResult.tags
            }
        })

        watch(queryError, (newError) => {
            console.log("query error", newError)
            if (newError) {
                error.value = newError.message
            }
        })
    }

    const createTags = async (tagNames: string[]): Promise<void> => {
        const { mutate, onDone, onError } = useMutation(createTagsQueryText)

        onDone((_) => {
            refetch()
        })

        onError((mutationError) => {
            error.value = mutationError.message
        })

        await mutate({
            input: tagNames.map(tagName => ({
                name: tagName,
                userId: userStore.user.id,
            })),
        })
    }

    onBeforeMount(fetchTags)

    return {
        tags,
        error,
        createTags,
    }
})
