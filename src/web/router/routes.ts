import LoginView from "@/views/LoginView.vue"
import RegisterView from "@/views/RegisterView.vue"

export enum Routes {
    HOME = "/",
    REGISTER = "/register",
    LOGIN = "/login",
}

export const routes = [
    { path: Routes.HOME, component: RegisterView, title: "Home" },
    { path: Routes.REGISTER, component: RegisterView, title: "Register" },
    { path: Routes.LOGIN, component: LoginView , title: "Login" },
]
