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
    personName: {
        type: String,
        default: "",
        required: false,
    },
})

const userStore = useUserStore()

const name = ref("")
const description = ref("")
const tags = ref([] as string[])

const errorMessages = ref([] as string[])
const success = ref(false)
const printErrorFunction = (error) => {
    errorMessages.value.push(error.message)
    success.value = false
}
const nameRules = [createFieldRequiredRule("Name")]

const upsertPersonMutationText = gql`
        mutation upsertPersonMutation(
                $create: PersonCreateInput!,
                $update: PersonUpdateInput!,
                $where: PersonWhereUniqueInput!
        ) {
            upsertOnePerson(create: $create, update: $update, where: $where) {
                id
            }
        }
`
const { mutate, onDone, onError } = useMutation(upsertPersonMutationText)

onDone(() => {
    success.value = true
})
onError(printErrorFunction)

const personQueryText = gql`
        query person($where: PersonWhereUniqueInput!) {
            person(where: $where) {
                id
                name
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
const { result, onError: personQueryOnError } = useQuery(personQueryText, {
    where: {
        userId_name: {
            name: props.personName,
            userId: userStore.user.id,
        },
    },
})

personQueryOnError(printErrorFunction)

let oldTags: DeepPartial<Tag>[] = []
const newlySelectedTags = computed(() => tags.value.filter((tag) => !oldTags.includes(tag)))
const newlyRemovedTags = computed(() => oldTags.filter((tag) => !tags.value.includes(tag)))
watch(result, (newResult) => {
    if (newResult.person) {
        name.value = newResult.person.name
        description.value = newResult.person.description
        tags.value = newResult.person.tags?.map((tag) => tag.tag.name) ?? []
        oldTags = tags.value
    } else {
        console.log("No person found")
    }
})

function onSubmit() {

    console.log("newlySelectedTags: ", newlySelectedTags.value)
    console.log("newlyRemovedTags: ", newlyRemovedTags.value)
    mutate({
        create: {
            name: name.value,
            description: description.value,
            tags: {
                create: tags.value.map((tag) => ({
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
                    username: userStore.user.username,
                },
            },
        },
        update: {
            name: { set: name.value },
            description: { set: description.value },
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
                                is: {
                                    AND: [
                                        {
                                            userId: { equals: userStore.user.id },
                                        },
                                        {
                                            name: { equals: tag },
                                        },
                                    ],
                                },
                            },
                        },
                        {
                            person: {
                                is: {
                                    AND: [
                                        {
                                            userId: { equals: userStore.user.id },
                                        }, {
                                            name: { equals: props.personName },
                                        },
                                    ],
                                },
                            },
                        },
                    ],
                })),
            },

            user: {
                connect: {
                    username: userStore.user.username,
                },
            },
        },
        where: {
            userId_name: {
                name: props.personName,
                userId: userStore.user.id,
            },
        },
    })
}

</script>

<template>
  <v-form
    validate-on="blur"
    clas="w-50"
    @submit.prevent="onSubmit"
  >
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you associate with this person most strongly"
      class="required"
    />
    <v-text-field
      v-model="description"
      label="What is this person like?"
    />
    <TagInput v-model="tags" />
    <v-btn
      type="submit"
    >
      {{ props.personName ? "Update" : "Create" }} Person
    </v-btn>
  </v-form>
  <p v-if="errorMessages">
    {{ errorMessages }}
  </p>
  <p v-if="success">
    Successfully executed {{ props.personName ? "update" : "create" }} query
  </p>
</template>

<style scoped>

</style>