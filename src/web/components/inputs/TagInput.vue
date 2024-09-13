<script setup lang="ts">
import { computed, ref, watch } from "vue"

import { useTagStore } from "@/stores/TagStore.js"

const tagStore = useTagStore()
const availableTags = ref(tagStore.tags.map((tag) => tag.name))
const selectedTags = ref([] as string[])
const search = ref("")

watch(selectedTags, (newSelectedTags, oldSelectedTags) => {
    const newlySelectedTags = newSelectedTags.filter((tagName) => !oldSelectedTags.includes(tagName))
    availableTags.value.push(...newlySelectedTags)
    const newlyDeselectedTags = oldSelectedTags.filter((tagName) => !newSelectedTags.includes(tagName))
    availableTags.value = availableTags.value.filter((tagName) => !newlyDeselectedTags.includes(tagName))
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