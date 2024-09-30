<script setup lang="ts">
import { MajorArcanaAlias } from "@client-types"
import {
    computed,
    ref,
    watch,
} from "vue"

import { doAllMajorArcanaInfosQuery } from "@/api/majorArcanaInfo/queries/fetchAllMajorArcanaInfos.js"
import { DeepPartial } from "@/utils/DeepPartial.js"
import { createFieldRequiredRule } from "@/utils/validationUtils.js"

const emit = defineEmits(["remove"])
const modelValue = defineModel<DeepPartial<MajorArcanaAlias>>({ required: true })
const props = defineProps({
    index: {
        type: Number,
        required: true,
    },
    alreadyUsedArcana: {
        type: Array<string>,
        required: false,
        default: [],
    },
})

const selectedArcana = ref(modelValue.value.majorArcanaInfo?.name)
const currentAlias = ref(modelValue.value.name)

watch([selectedArcana, currentAlias], ([newArcana, newAlias]) => {
    modelValue.value = {
        majorArcanaInfo: {
            name: newArcana,
        },
        name: newAlias,
    }
})

const { result, onError } = doAllMajorArcanaInfosQuery()

const arcanaToBeDisplayed = computed(() => (
    result.value?.majorArcanaInfos?.map((arcana) => arcana.name).filter((arcana) => (
        !props.alreadyUsedArcana?.includes(arcana)
    )) || []
))

onError((error) => {
    console.error(error)
})

const arcanaRules = [createFieldRequiredRule("Arcana")]
const aliasRules = [createFieldRequiredRule("Alias")]
</script>
<template>
  <v-container>
    <v-row>
      <v-col cols="5">
        <v-select
          v-model="selectedArcana"
          :items="arcanaToBeDisplayed"
          label="Arcana"
          :rules="arcanaRules"
          item-text="name"
          item-value="id"
          class="required"
          outlined
        />
      </v-col>
      <v-col cols="5">
        <v-text-field
          v-model="currentAlias"
          label="Alias"
          :rules="aliasRules"
          class="required"
        />
      </v-col>
      <v-col cols="2">
        <v-btn
          icon
          @click="emit('remove', props.index)"
        >
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>
