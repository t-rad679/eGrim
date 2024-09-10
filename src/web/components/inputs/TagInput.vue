<script setup lang="ts">
import { useMutation, useQuery } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { computed, ref } from "vue"

import { useUserStore } from "@/stores/UserStore.js"

const fetchTags = gql`
  query fetchTags {
    tags {
      name
    }
  }
`

const userStore = useUserStore()
const user = computed(() => userStore.user)

const createTagMutationText = gql`
  mutation createTag($input: TagCreateInput!) {
    createOneTag(data: $input) {
      name
    }
  }
`
const { result: tagsResult } = useQuery(fetchTags)
const { mutate: createTagMutation, onDone: createTagOnDone, onError: createTagOnError } = useMutation(createTagMutationText)
const selectedTags = ref([])
const search = ref("")
const error = ref("")
const availableTags = computed(() => {
    return tagsResult.value?.tags.filter(tag =>
        !selectedTags.value.some(selectedTag => selectedTag.id === tag.id),
    ) || []
})
const addTag = (tag) => {
    selectedTags.value.push(tag)
}
const createTag = async (tagName) => {
    console.log(tagName)
    createTagOnDone((data) => {
        addTag(data.createTag)
    })
    createTagOnError((createTagError) => {
        console.error(createTagError)
        error.value = createTagError.message
    })
    await createTagMutation({
        input: {
            name: tagName,
            user: {
                connect: {
                    username: user.value.name,
                },
            },
        },
    })
}
const onTagSelected = (tagName) => {
    const existingTag = availableTags.value.find(tag => tag.name === tagName)
    if (existingTag) {
        addTag(existingTag)
    } else {
        createTag(tagName)
    }
}
</script>
<template>
  <v-combobox
    v-model:search="search"
    v-model:selected-items="selectedTags"
    :hide-no-data="false"
    auto-select-first
    clear-on-select
    clearable
    chips
    label="Tags"
    multiple
    :items="availableTags"
    @update:model-value="onTagSelected"
  >
    <template #no-data>
      <v-list-item>
        <v-list-item-title>
          Press enter to create tag {{ search }}
        </v-list-item-title>
      </v-list-item>
    </template>
  </v-combobox>
  <div v-if="!!error">
    {{ error }}
  </div>
</template>
<style scoped>
</style>