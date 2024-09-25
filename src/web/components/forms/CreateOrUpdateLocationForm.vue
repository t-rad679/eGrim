<script setup lang="ts">

import {
    Tag,
    TagToObjectRelation,
} from "@client-types"
import {
    ref,
    watch,
} from "vue"

import {
    createUpsertLocationMutation,
    doUpsertLocation,
} from "@/api/location/mutations/upsertLocation.js"
import { doLocationQuery } from "@/api/location/queries/fetchLocation.js"
import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore"
import { DeepPartial } from "@/utils/DeepPartial"
import { createFieldRequiredRule } from "@/utils/validationUtils"

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

const success = ref(false)
const errorMessage = ref("")

const userStore = useUserStore()
const username = userStore.user.username

const nameRules = [createFieldRequiredRule("Name")]

let oldTags: DeepPartial<Tag>[] = []
let locationId = ""

const { result, onError: locationQueryOnError } = doLocationQuery(props.locationName, userStore.user.id)

watch(result, (newResult) => {
    if (newResult?.location) {
        name.value = newResult.location.name
        locationId = newResult.location.id
        address.value = newResult.location.address ?? ""
        city.value = newResult.location.city ?? ""
        state.value = newResult.location.state ?? ""
        zip.value = newResult.location.zip ?? ""
        country.value = newResult.location.country ?? ""
        description.value = newResult.location.description ?? ""
        tags.value = newResult.location.tags.map((tag: TagToObjectRelation) => tag.tag.name) ?? []
        oldTags = newResult.location.tags.map((tag: TagToObjectRelation) => tag.tag) ?? []
    }
})

locationQueryOnError((error) => {
    console.log(error)
    errorMessage.value = error.message
})

const {
    mutate,
    onDone,
    onError: upsertLocationOnError,
} = createUpsertLocationMutation()
onDone((_) => {
    success.value = true
})

upsertLocationOnError((error) => {
    errorMessage.value = error.message
})
function onSubmit() {
    doUpsertLocation(
        mutate,
        name.value,
        username,
        userStore.user.id,
        address.value,
        city.value,
        state.value,
        zip.value,
        country.value,
        description.value,
        tags.value.filter((tag) => !oldTags.map((tag) => tag.name ?? "").includes(tag)),
        oldTags.filter((tag) => !tags.value.includes(tag.name ?? "")).map((tag) => tag.id ?? ""),
        locationId,
        props.locationName,
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
