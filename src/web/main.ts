import "./assets/main.css"
import "vuetify/styles"

import { ApolloClient, InMemoryCache, createHttpLink } from "@apollo/client/core"
import { DefaultApolloClient } from "@vue/apollo-composable"
import { createApp, h, provide } from "vue"
import { createVuetify } from "vuetify"
import { aliases, mdi } from "vuetify/iconsets/mdi"

import App from "@/App.vue"
import router from "@/router/router"


const httpLink = createHttpLink({
    uri: "http://localhost:4000/graphql",
})

const cache = new InMemoryCache()

const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
})

const vuetify = createVuetify({
    icons: {
        defaultSet: "mdi",
        aliases,
        sets: {
            mdi,
        },
    },
})
createApp({
    setup() {
        provide(DefaultApolloClient, apolloClient)
    },
    render: () => h(App),
})
    .use(router)
    .use(vuetify)
    .mount("#app")
