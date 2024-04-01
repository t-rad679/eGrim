import LoginView from "@/components/LoginView.vue"
import RegisterView from "@/components/RegisterView.vue"

export enum Routes {
    REGISTER = "/register",
    LOGIN = "/login",
}

export const routes = [
    { path: Routes.REGISTER, component: RegisterView },
    { path: Routes.LOGIN, component: LoginView },
]