<script setup lang="ts">

import { Tag } from "@client-types"
import { useMutation, useQuery } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { computed, ref, watch } from "vue"

import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore.js"
import { DeepPartial } from "@/utils/DeepPartial.js"
import { createFieldRequiredRule } from "@/utils/validationUtils.js"

const props = defineProps({
    locationName: {
        type: String,
        default: "",
        required: false,
    },
})

const name = ref("")
const address = ref("")
const city = ref("")
const state = ref("")
const country = ref("")
const zip = ref("")
const tags = ref([] as string[])
const description = ref("")

let oldTags: DeepPartial<Tag>[] = []
const newlySelectedTags = computed(() => tags.value.filter((tag) => !oldTags.map((oldTag) => oldTag.name).includes(tag)))
const newlyRemovedTags = computed(() => oldTags.map((oldTag) => oldTag.name).filter((tag) => !tags.value.includes(tag)))

const success = ref(false)
const errorMessage = ref("")

const userStore = useUserStore()
const username = userStore.user.username

const nameRules = [createFieldRequiredRule("Name")]

const locationQueryText = gql`
        query location($where: LocationWhereUniqueInput!) {
            location(where: $where) {
                id
                name
                address
                city
                state
                zip
                country
                description
                tags {
                    tag {
                        id
                        name
                    }
                }
            }
        }
    `

const { result, onError: locationQueryOnError } = useQuery(locationQueryText, {
    where: {
        userId_name: {
            name: props.locationName,
            userId: userStore.user.id,
        },
    },
})

watch(result, (newResult) => {
    if (newResult.location) {
        name.value = newResult.location.name
        address.value = newResult.location.address
        city.value = newResult.location.city
        state.value = newResult.location.state
        zip.value = newResult.location.zip
        country.value = newResult.location.country
        description.value = newResult.location.description
        tags.value = newResult.location.tags.map((tag) => tag.tag.name)
        oldTags = newResult.location.tags
    }
})

locationQueryOnError((error) => {
    errorMessage.value = error.message
})

const locationUpsertMutationText = gql`
        mutation upsertLocation($create: LocationCreateInput!, $update: LocationUpdateInput!, $where: LocationWhereUniqueInput!) {
            upsertOneLocation(create: $create, update: $update, where: $where) {
                id
            }
        }
    `
const {
    mutate,
    onDone,
    onError: upsertLocationOnError,
} = useMutation(locationUpsertMutationText)

function onSubmit() {
    async function createLocation(
        name: string,
        address: string,
        city: string,
        state: string,
        zip: string,
        country: string,
        description: string,
        tags: string[],
    ) {
        onDone((_) => {
            success.value = true
        })

        upsertLocationOnError((error) => {
            errorMessage.value = error.message
        })
        await mutate({
            create: {
                name,
                address,
                city,
                state,
                zip,
                country,
                description,
                tags: {
                    create: tags.map((tag) => ({
                        tag: {
                            connectOrCreate: {
                                create: {
                                    name: tag,
                                    user: {
                                        connect: {
                                            username: userStore.user.username,
                                        },
                                    },
                                },
                                where: {
                                    userId_name: {
                                        userId: userStore.user.id,
                                        name: tag,
                                    },
                                },
                            },
                        },
                    })),
                },
                user: {
                    connect: {
                        username,
                    },
                },
            },
            update: {
                name: { set: name },
                address: { set: address },
                city: { set: city },
                state: { set: state },
                zip: { set: zip },
                country: { set: country },
                description: { set: description },
                tags: {
                    create: newlySelectedTags.value.map((tag) => ({
                        tag: {
                            connectOrCreate: {
                                create: {
                                    name: tag,
                                    user: {
                                        connect: {
                                            username: userStore.user.username,
                                        },
                                    },
                                },
                                where: {
                                    userId_name: {
                                        userId: userStore.user.id,
                                        name: tag,
                                    },
                                },
                            },
                        },
                    })),
                    delete: newlyRemovedTags.value.map((tag) => ({
                        AND: [
                            {
                                tag: {
                                    userId_name: {
                                        userId: userStore.user.id,
                                        name: tag,
                                    },
                                },
                            },
                            {
                                location: {
                                    userId_name: {
                                        userId: userStore.user.id,
                                        name: name,
                                    },
                                },
                            },
                        ],
                    })),
                },
                user: {
                    connect: {
                        username,
                    },
                },
            },
            where: {
                userId_name: {
                    name,
                    userId: userStore.user.id,
                },
            },
        })
    }

    createLocation(
        name.value,
        address.value,
        city.value,
        state.value,
        zip.value,
        country.value,
        description.value,
        tags.value,
    )
}

</script>

<template>
  <v-form
    validate-on="blur"
    class="w-50"
    @submit.prevent="onSubmit"
  >
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you want to identify this location by"
      class="required"
    />
    <v-text-field
      v-model="address"
      label="The street address of the location"
    />
    <v-text-field
      v-model="city"
      label="The city of the location"
    />
    <v-text-field
      v-model="state"
      label="The state or province of the location"
    />
    <v-text-field
      v-model="zip"
      label="The postal code of the location"
    />
    <v-text-field
      v-model="country"
      label="The three letter country code of the location"
    />
    <v-text-field
      v-model="description"
      label="What kind of place is it? What is it like?"
    />
    <TagInput v-model="tags" />
    <v-btn type="submit">
      Create Location
    </v-btn>
  </v-form>
  {{ success }}
  <p v-if="errorMessage">
    {{ errorMessage }}
  </p>
</template>

<style scoped>

</style>