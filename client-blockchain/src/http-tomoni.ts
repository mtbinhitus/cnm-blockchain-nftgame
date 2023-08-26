// import axios, { type AxiosInstance, type InternalAxiosRequestConfig } from "axios";
// import { useAuthStore } from "./stores/auth";
// import { getAuth } from "firebase/auth";
// import { getActiveLocale } from "./i18n/translation";

// function setDefaultConfig(config: InternalAxiosRequestConfig) {
//   config.headers.set("Accept-Language", getActiveLocale());
//   config.headers.set("Accept", "application/json");
//   config.headers.set("X-Organization-Scope", import.meta.env.VITE_APP_ORGANIZATION);

//   return new Promise<InternalAxiosRequestConfig>((resolve) => {
//     if (useAuthStore().idToken) {
//       config.headers.set("X-Firebase-IDToken", useAuthStore().idToken);
//       resolve(config);
//     } else {
//       getAuth().onAuthStateChanged(() => {
//         const currentUser = getAuth().currentUser;
//         if (currentUser) {
//           currentUser.getIdToken().then((token) => {
//             useAuthStore().idToken = token;
//             config.headers.set("X-Firebase-IDToken", token);
//             resolve(config);
//           });
//         } else {
//           resolve(config);
//         }
//       });
//     }
//   });
// }

// const tomoni: AxiosInstance = axios.create({
//   baseURL: import.meta.env.VITE_APP_TOMONI_HOST,
// });
// tomoni.interceptors.request.use((config: InternalAxiosRequestConfig) => {
//   return setDefaultConfig(config);
// });

// const ikom: AxiosInstance = axios.create({
//   baseURL: import.meta.env.VITE_APP_IKOM_HOST,
// });
// ikom.interceptors.request.use((config: InternalAxiosRequestConfig) => {
//   return setDefaultConfig(config);
// });

// export { tomoni, ikom };
