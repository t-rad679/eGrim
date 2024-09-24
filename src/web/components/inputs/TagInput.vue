<script setup lang="ts">
import {
    computed,
    ref,
    watch,
} from "vue"

import { useTagStore } from "@/stores/TagStore"

const tagStore = useTagStore()
const dbTags = computed(() => tagStore.tags.map((tag) => tag.name))
const selectedNonDbTags = ref([] as string[])
const availableTags = computed(() => [...dbTags.value, ...selectedNonDbTags.value])
const selectedTags = ref([] as string[])
const search = ref("")

watch(selectedTags, (newSelectedTags, oldSelectedTags) => {
    selectedNonDbTags.value.push(...newSelectedTags
        .filter((tagName) => !oldSelectedTags.includes(tagName))
        .filter((tagName) => !availableTags.value.includes(tagName)))
    selectedNonDbTags.value = selectedNonDbTags.value
        .filter((tagName) => !oldSelectedTags
            .filter((tagName) => !newSelectedTags.includes(tagName)).includes(tagName))
    search.value = ""
})

</script>
<template>
  <v-combobox
    v-model:search="search"
    v-model="selectedTags"
    :hide-no-data="false"
    auto-select-first
    clear-on-select
    clearable
    chips
    label="Tags"
    multiple
    :items="availableTags"
  >
    <template #no-data>
      <v-list-item>
        <v-list-item-title>
          Press enter to create tag {{ search }}
        </v-list-item-title>
      </v-list-item>
    </template>
  </v-combobox>
</template>
<style scoped>
</style>