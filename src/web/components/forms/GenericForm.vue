<script setup lang="ts">

const { submitFn, isFormChanged = false, isUpdate = false, customInvalidMessage = "" } = defineProps<{
    submitFn: (e: SubmitEvent) => unknown
    isFormChanged?: boolean
    isUpdate?: boolean
    customInvalidMessage?: string
}>()

const isFormValid = defineModel<boolean | null>({ required: true })
</script>

<template>
  <v-form
    v-model="isFormValid"
    validate-on="input"
    class="w-75"
    @submit.prevent="submitFn"
  >
    <slot />
    <div />
    <v-btn
      type="submit"
      :disabled="!isFormValid || !isFormChanged"
    >
      {{ isUpdate ? "Save" : "Create" }}
    </v-btn>
    <v-alert
      v-if="!isFormValid || customInvalidMessage"
      icon="$error"
      color="error"
      theme="dark"
      variant="tonal"
    >
      <template v-if="customInvalidMessage">
        {{ customInvalidMessage }}
      </template>
      <template v-else>
        Please fill out all required fields.
      </template>
    </v-alert>
    <v-alert
      v-if="!isFormChanged && isUpdate"
      icon="$warning"
      color="warning"
      theme="dark"
      variant="tonal"
    >
      No changes made.
    </v-alert>
  </v-form>
</template>

<style scoped>

</style>
