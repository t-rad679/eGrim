import LoginView from "@/web/components/LoginView.vue"
import RegisterView from "@/web/components/RegisterView.vue"

export enum Routes {
    REGISTER = "/register",
    LOGIN = "/login",
}

export const routes = [
    { path: Routes.REGISTER, component: RegisterView },
    { path: Routes.LOGIN, component: LoginView },
]